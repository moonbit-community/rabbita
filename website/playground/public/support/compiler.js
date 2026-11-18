import { createMooncWorker } from "./rpc.js?v=assets-4";

const manifestUrl = new URL("../moonbit-assets/manifest.json?v=assets-4", import.meta.url).href;
const textDecoder = new TextDecoder("utf-8");
let manifestPromise;
let stdMiFilesPromise;
const bytesCache = new Map();
const textCache = new Map();
const packageBuildCache = new Map();
let manifestBaseUrl = "";
let manifestRevision = "";

export async function loadManifest() {
  if (!manifestPromise) {
    manifestPromise = fetch(manifestUrl, { cache: "no-store" }).then(async (response) => {
      if (!response.ok) {
        throw new Error(
          "Missing compiler assets. Run `moon run --target native scripts/assets.mbtx` first.",
        );
      }
      manifestBaseUrl = new URL(".", response.url).href;
      const manifest = await response.json();
      manifestRevision = String(manifest.generatedAt || "");
      return manifest;
    });
  }
  return manifestPromise;
}

function assetUrl(url) {
  const resolved = new URL(url, manifestBaseUrl);
  if (manifestRevision) {
    resolved.searchParams.set("v", manifestRevision);
  }
  return resolved.href;
}

async function fetchBytes(url) {
  const resolved = assetUrl(url);
  if (!bytesCache.has(resolved)) {
    bytesCache.set(
      resolved,
      fetch(resolved).then(async (response) => {
        if (!response.ok) {
          throw new Error(`Failed to load asset ${resolved}`);
        }
        return new Uint8Array(await response.arrayBuffer());
      }),
    );
  }
  return bytesCache.get(resolved);
}

async function fetchText(url) {
  const resolved = assetUrl(url);
  if (!textCache.has(resolved)) {
    textCache.set(
      resolved,
      fetch(resolved)
        .then(async (response) => {
          if (!response.ok) {
            throw new Error(`Failed to load asset ${resolved}`);
          }
          return response.text();
        })
        .catch((error) => {
          throw new Error(`Failed to fetch ${resolved}: ${error.message || error}`);
        }),
    );
  }
  return textCache.get(resolved);
}

function isCorePackage(pkg) {
  return pkg.startsWith("moonbitlang/core/");
}

function defaultAliasForPath(path) {
  return path.split("/").at(-1);
}

function stripLineComments(source) {
  return source
    .split("\n")
    .map((line) => line.replace(/\/\/.*$/, ""))
    .join("\n");
}

function parseMoonPkgImports(source) {
  const imports = [];
  const seen = new Set();
  const add = (path, alias) => {
    if (seen.has(path)) {
      return;
    }
    seen.add(path);
    imports.push({ path, alias: alias || defaultAliasForPath(path) });
  };
  const cleaned = stripLineComments(source || "");
  const importBlocks = cleaned.matchAll(/(?:^|\n)\s*import\s*\{([\s\S]*?)\}/g);
  for (const blockMatch of importBlocks) {
    const block = blockMatch[1];
    const entries = block.matchAll(/"([^"]+)"\s*(?:@([A-Za-z_][A-Za-z0-9_]*))?/g);
    for (const entry of entries) {
      add(entry[1], entry[2] || "");
    }
  }
  add("moonbitlang/core/prelude", "prelude");
  return imports;
}

function collectReachablePackages(manifest, mainImports) {
  const packages = manifest.packages;
  const visited = new Set();
  const order = [];

  function visit(id) {
    if (isCorePackage(id) || visited.has(id)) {
      return;
    }
    const pkg = packages[id];
    if (!pkg) {
      throw new Error(`Package asset is not available for ${id}`);
    }
    visited.add(id);
    for (const dep of pkg.deps) {
      visit(dep.path);
    }
    order.push(id);
  }

  for (const dep of mainImports) {
    visit(dep.path);
  }
  return order;
}

async function fileSpecsToWorkerFiles(files) {
  return Promise.all(files.map(async (file) => [file.spec, await fetchBytes(file.url)]));
}

async function stdMiFilesForManifest(manifest) {
  if (!stdMiFilesPromise) {
    stdMiFilesPromise = fileSpecsToWorkerFiles(manifest.core.interfaces);
  }
  return stdMiFilesPromise;
}

async function sourceFiles(pkg) {
  return Promise.all(pkg.sources.map(async (source) => [source.name, await fetchText(source.url)]));
}

function transitivePackageIds(manifest, id, seen = new Set()) {
  const pkg = manifest.packages[id];
  if (!pkg) {
    return seen;
  }
  for (const dep of pkg.deps) {
    if (isCorePackage(dep.path) || seen.has(dep.path)) {
      continue;
    }
    seen.add(dep.path);
    transitivePackageIds(manifest, dep.path, seen);
  }
  return seen;
}

function miSpecForPackage(id, alias) {
  const stem = id.split("/").at(-1);
  const spec = `/packages/${id}/${stem}.mi`;
  return alias ? `${spec}:${alias}` : spec;
}

function coreInterfaceForPackage(manifest, id) {
  const found = manifest.core.interfaces.find((item) => item.path === id);
  if (!found) {
    throw new Error(`Core interface is not available for ${id}`);
  }
  return found;
}

function miSpecForCorePackage(manifest, id, alias) {
  const iface = coreInterfaceForPackage(manifest, id);
  const specPath = iface.spec.split(":")[0];
  return `${specPath}:${alias || defaultAliasForPath(id)}`;
}

async function directMiFilesForDeps(manifest, deps, builtPackages) {
  return Promise.all(deps.map(async (dep) => {
    if (isCorePackage(dep.path)) {
      const iface = coreInterfaceForPackage(manifest, dep.path);
      return [miSpecForCorePackage(manifest, dep.path, dep.alias), await fetchBytes(iface.url)];
    }
    const built = builtPackages.get(dep.path);
    if (!built?.mi) {
      throw new Error(`Package ${dep.path} was not built before its dependent package.`);
    }
    return [miSpecForPackage(dep.path, dep.alias), built.mi];
  }));
}

function indirectMiFilesForPackage(manifest, id, builtPackages) {
  const pkg = manifest.packages[id];
  const direct = new Set(
    (pkg?.deps || []).filter((dep) => !isCorePackage(dep.path)).map((dep) => dep.path),
  );
  return Array.from(transitivePackageIds(manifest, id))
    .filter((depId) => !direct.has(depId))
    .map((depId) => [miSpecForPackage(depId), builtPackages.get(depId).mi]);
}

function indirectMiFilesForMain(manifest, builtPackages, mainImports) {
  const direct = new Set(
    mainImports
      .filter((dep) => !isCorePackage(dep.path))
      .map((dep) => dep.path),
  );
  const transitive = new Set();
  for (const dep of direct) {
    for (const transitiveDep of transitivePackageIds(manifest, dep)) {
      transitive.add(transitiveDep);
    }
  }
  return Array.from(transitive)
    .filter((depId) => !direct.has(depId))
    .map((depId) => [miSpecForPackage(depId), builtPackages.get(depId).mi]);
}

function parseDiagnostics(diagnostics) {
  return diagnostics.map((item) => {
    try {
      return JSON.parse(item);
    } catch {
      return item;
    }
  });
}

function displayPath(path) {
  return (path || "main.mbt")
    .replace(/^playground:\/main\//, "")
    .replace(/^playground:\//, "");
}

function parseLoc(loc) {
  if (typeof loc === "string") {
    const match = loc.match(/^(\d+):(\d+)-(\d+):(\d+)$/);
    if (match) {
      return {
        line: Number(match[1]),
        column: Number(match[2]),
        endLine: Number(match[3]),
        endColumn: Number(match[4]),
      };
    }
    const point = loc.match(/^(\d+):(\d+)$/);
    if (point) {
      const line = Number(point[1]);
      const column = Number(point[2]);
      return { line, column, endLine: line, endColumn: column + 1 };
    }
  }
  if (loc && typeof loc === "object") {
    const start = loc.start || loc.range?.start || loc;
    const end = loc.end || loc.range?.end || start;
    const line = start.line ?? start.row ?? loc.line ?? 0;
    const column = start.col ?? start.column ?? start.character ?? loc.col ?? 0;
    const endLine = end.line ?? end.row ?? loc.endLine ?? line;
    const endColumn = end.col ?? end.column ?? end.character ?? loc.endColumn ?? column + 1;
    return { line, column, endLine, endColumn };
  }
  return { line: 0, column: 0, endLine: 0, endColumn: 0 };
}

function normalizeDiagnostic(diag) {
  if (typeof diag === "string") {
    return {
      level: /\bWarning\b/.test(diag) ? "warning" : "error",
      path: "main.mbt",
      line: 0,
      column: 0,
      endLine: 0,
      endColumn: 0,
      message: diag.trim(),
    };
  }
  const loc = parseLoc(diag.loc || diag.location);
  return {
    level: diag.level || (/\bWarning\b/.test(diag.message || "") ? "warning" : "error"),
    path: displayPath(diag.path || diag.file || diag.loc?.path || diag.location?.path),
    line: loc.line,
    column: loc.column,
    endLine: loc.endLine,
    endColumn: loc.endColumn,
    message: diag.message || diag.rendered || JSON.stringify(diag),
  };
}

function visibleDiagnostics(diagnostics) {
  const items = parseDiagnostics(diagnostics).map(normalizeDiagnostic);
  const hasError = items.some((item) => item.level !== "warning");
  return hasError ? items.filter((item) => item.level !== "warning") : items;
}

function diagnosticText(item) {
  if (item.line > 0 && item.column > 0) {
    return `${item.path}:${item.line}:${item.column} ${item.message}`;
  }
  return `${item.path}: ${item.message}`;
}

function diagnosticsToText(items) {
  return items.map(diagnosticText).join("\n");
}

export async function compileMbtToJs(mbtSource, moonPkgSource = "") {
  const manifest = await loadManifest();
  const mainImports = parseMoonPkgImports(moonPkgSource);
  const reachableOrder = collectReachablePackages(manifest, mainImports);
  const worker = createMooncWorker(manifest.generatedAt);

  try {
    const stdMiFiles = await stdMiFilesForManifest(manifest);
    const builtPackages = new Map();

    for (const packageId of reachableOrder) {
      if (!packageBuildCache.has(packageId)) {
        const pkg = manifest.packages[packageId];
        packageBuildCache.set(
          packageId,
          worker.buildPackage({
            mbtFiles: await sourceFiles(pkg),
            miFiles: await directMiFilesForDeps(manifest, pkg.deps, builtPackages),
            indirectImportMiFiles: indirectMiFilesForPackage(manifest, packageId, builtPackages),
            stdMiFiles,
            target: "js",
            pkg: packageId,
            pkgSources: manifest.pkgSources,
            isMain: false,
            errorFormat: "json",
            enableValueTracing: false,
            noOpt: false,
          }),
        );
      }

      let result;
      try {
        result = await packageBuildCache.get(packageId);
      } catch (error) {
        packageBuildCache.delete(packageId);
        throw error;
      }
      if (!result.core || !result.mi) {
        packageBuildCache.delete(packageId);
        const diagnostics = visibleDiagnostics(result.diagnostics);
        return {
          ok: false,
          diagnostics: `Failed to build ${packageId}\n${diagnosticsToText(diagnostics)}`,
          diagnosticItems: diagnostics,
        };
      }
      builtPackages.set(packageId, result);
    }

    let buildResult;
    try {
      buildResult = await worker.buildPackage({
        mbtFiles: [["main.mbt", mbtSource]],
        miFiles: await directMiFilesForDeps(manifest, mainImports, builtPackages),
        indirectImportMiFiles: indirectMiFilesForMain(manifest, builtPackages, mainImports),
        stdMiFiles,
        target: "js",
        pkg: manifest.mainPackage,
        pkgSources: manifest.pkgSources,
        isMain: true,
        errorFormat: "json",
        enableValueTracing: false,
        noOpt: false,
      });
    } catch (error) {
      throw new Error(`buildPackage failed: ${error.message || error}`);
    }

    if (!buildResult.core || !buildResult.mi) {
      const diagnostics = visibleDiagnostics(buildResult.diagnostics);
      return {
        ok: false,
        diagnostics: diagnosticsToText(diagnostics),
        diagnosticItems: diagnostics,
      };
    }

    const dependencyCoreFiles = reachableOrder.map((id) => builtPackages.get(id).core);
    const coreFiles = await Promise.all([
      fetchBytes(manifest.core.core),
      ...dependencyCoreFiles,
      buildResult.core,
    ]);

    let linkResult;
    try {
      linkResult = await worker.linkCore({
        coreFiles,
        main: manifest.mainPackage,
        pkgSources: manifest.pkgSources,
        target: "js",
        exportedFunctions: [],
        outputFormat: "wasm",
        testMode: false,
        debug: false,
        noOpt: false,
        sourceMap: false,
        sources: {},
        stopOnMain: false,
      });
    } catch (error) {
      throw new Error(`linkCore failed: ${error.message || error}`);
    }

    return {
      ok: true,
      js: textDecoder.decode(linkResult.result),
      packageCount: reachableOrder.length,
      coreInterfaceCount: manifest.core.interfaces.length,
    };
  } finally {
    worker.terminate();
  }
}
