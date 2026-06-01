import type { Plugin, ViteDevServer } from 'vite';
import { spawnSync } from 'child_process';
import fs from 'fs';
import path from 'path';

type MoonProjectConfig = {
  moduleRoot: string;
  modPath: string;
  workspaceRoot?: string;
};

type MoonBuildPackage = {
  'is-main'?: boolean;
  root?: string;
  rel?: string;
  'root-path'?: string;
};

type MoonBuildMetadata = {
  packages?: MoonBuildPackage[];
};

type BuildMode = 'debug' | 'release';

type JsOutput = {
  jsPath: string;
  sourceMapPath?: string;
};

type RabbitaOptions = {
  main?: string;
  moonModDir?: string;
};

const VIRTUAL_MAIN_ENTRY_ID = '\0rabbita:main-entry';

function defaultProjectRoot(): string {
  return process.env.INIT_CWD ?? process.cwd();
}

function normalizePathLike(input: string): string {
  return input.replaceAll('\\', '/').replace(/^\/+|\/+$/g, '');
}

function moduleOutputName(modPath: string): string {
  const normalized = normalizePathLike(modPath);
  const segments = normalized.split('/').filter(Boolean);
  return segments[segments.length - 1] ?? normalized;
}

function findNearestMoonWork(startDir: string): string | undefined {
  let current = startDir;
  while (true) {
    const workPath = path.join(current, 'moon.work');
    if (fs.existsSync(workPath)) {
      return current;
    }
    const parent = path.dirname(current);
    if (parent === current) {
      return undefined;
    }
    current = parent;
  }
}

function parseMoonModName(content: string, filePath: string): string {
  const match = content.match(/^\s*name\s*=\s*("(?:\\.|[^"\\])*")/m);
  if (!match) {
    throw new Error(`Field "name" is missing in ${filePath}`);
  }

  try {
    return JSON.parse(match[1]) as string;
  } catch (err: any) {
    throw new Error(`Cannot parse field "name" in ${filePath}: ${err.message}`);
  }
}

function probeMoonBitProject(moduleRoot: string): MoonProjectConfig {
  const modFilePath = path.join(moduleRoot, 'moon.mod');
  const modJsonPath = path.join(moduleRoot, 'moon.mod.json');
  if (fs.existsSync(modFilePath)) {
    return {
      moduleRoot,
      modPath: parseMoonModName(fs.readFileSync(modFilePath, 'utf8'), modFilePath),
      workspaceRoot: findNearestMoonWork(moduleRoot),
    };
  }

  if (!fs.existsSync(modJsonPath)) {
    throw new Error(`Cannot find moon.mod or moon.mod.json in ${moduleRoot}`);
  }

  const json = JSON.parse(fs.readFileSync(modJsonPath, 'utf8')) as { name?: string };
  if (!json.name) {
    throw new Error(`Field "name" is missing in ${modJsonPath}`);
  }

  return {
    moduleRoot,
    modPath: json.name,
    workspaceRoot: findNearestMoonWork(moduleRoot),
  };
}

function buildRootCandidates(project: MoonProjectConfig): Array<string> {
  const candidates = project.workspaceRoot
    ? [path.join(project.workspaceRoot, '_build'), path.join(project.moduleRoot, '_build')]
    : [path.join(project.moduleRoot, '_build')];
  return [...new Set(candidates.map(candidate => path.resolve(candidate)))];
}

function readBuildMetadata(buildRoot: string): MoonBuildMetadata | undefined {
  const metadataPath = path.join(buildRoot, 'packages.json');
  if (fs.existsSync(metadataPath)) {
    return JSON.parse(fs.readFileSync(metadataPath, 'utf8')) as MoonBuildMetadata;
  }
  return undefined;
}

function pickMainPackage(
  metadata: MoonBuildMetadata | undefined,
  modulePath: string,
  preferredPackagePath?: string,
  allowFallback = true,
): MoonBuildPackage | undefined {
  const mainPackages = (metadata?.packages ?? []).filter(pkg => pkg['is-main'] === true);
  if (mainPackages.length === 0) {
    return undefined;
  }

  if (preferredPackagePath) {
    const normalizedExpected = normalizePathLike(preferredPackagePath);
    const matched = mainPackages.find(pkg => {
      const rel = normalizePathLike(pkg.rel ?? '');
      const rootPath = normalizePathLike(pkg['root-path'] ?? '');
      return rel === normalizedExpected
        || rel.endsWith(`/${normalizedExpected}`)
        || rootPath.endsWith(`/${normalizedExpected}`);
    });
    if (matched) {
      return matched;
    }
  }

  const ownModuleMain = mainPackages.find(pkg => pkg.root === modulePath);
  if (ownModuleMain) {
    return ownModuleMain;
  }

  if (!allowFallback) {
    return undefined;
  }

  return mainPackages[0];
}

function collectJsFiles(buildDir: string): Array<string> {
  if (!fs.existsSync(buildDir)) {
    return [];
  }

  const files: Array<string> = [];
  const worklist: Array<string> = [buildDir];
  while (worklist.length > 0) {
    const current = worklist.pop()!;
    for (const entry of fs.readdirSync(current)) {
      if (entry === '.mooncakes') {
        continue;
      }
      const fullPath = path.join(current, entry);
      const stat = fs.statSync(fullPath);
      if (stat.isDirectory()) {
        worklist.push(fullPath);
      } else if (entry.endsWith('.js')) {
        files.push(fullPath);
      }
    }
  }
  return files;
}

function toJsOutput(jsPath: string): JsOutput {
  const mapPath = `${jsPath}.map`;
  return {
    jsPath,
    sourceMapPath: fs.existsSync(mapPath) ? mapPath : undefined,
  };
}

function findJsOutputInBuildRoot(
  buildRoot: string,
  mode: BuildMode,
  modPath: string,
  mainPkg?: MoonBuildPackage,
): JsOutput | undefined {
  const buildDir = path.join(buildRoot, 'js', mode, 'build');
  if (!fs.existsSync(buildDir)) {
    return undefined;
  }

  const moduleName = moduleOutputName(modPath);
  const packageRoot = normalizePathLike(mainPkg?.root ?? '');
  const packageRel = normalizePathLike(mainPkg?.rel ?? '');

  const explicitCandidates: Array<string> = [path.join(buildDir, `${moduleName}.js`)];
  if (packageRel !== '') {
    explicitCandidates.push(path.join(buildDir, packageRel, `${path.basename(packageRel)}.js`));
    explicitCandidates.push(path.join(buildDir, `${packageRel}.js`));
  }
  if (packageRoot !== '' && packageRel !== '') {
    explicitCandidates.push(
      path.join(buildDir, packageRoot, packageRel, `${path.basename(packageRel)}.js`),
    );
  }
  if (packageRoot !== '') {
    explicitCandidates.push(path.join(buildDir, packageRoot, `${moduleOutputName(packageRoot)}.js`));
  }

  for (const candidate of explicitCandidates) {
    if (fs.existsSync(candidate)) {
      return toJsOutput(candidate);
    }
  }

  const discovered = collectJsFiles(buildDir);
  if (discovered.length === 0) {
    return undefined;
  }

  const byModuleName = discovered.find(file => path.basename(file) === `${moduleName}.js`);
  if (byModuleName) {
    return toJsOutput(byModuleName);
  }

  if (packageRoot !== '' && packageRel !== '') {
    const rootRelSuffix = normalizePathLike(
      path.join(packageRoot, packageRel, `${path.basename(packageRel)}.js`),
    );
    const byRootAndRel = discovered.find(file => normalizePathLike(file).endsWith(rootRelSuffix));
    if (byRootAndRel) {
      return toJsOutput(byRootAndRel);
    }
  }

  if (packageRel !== '') {
    const relSuffix = normalizePathLike(path.join(packageRel, `${path.basename(packageRel)}.js`));
    const byPackageRel = discovered.find(file => normalizePathLike(file).endsWith(relSuffix));
    if (byPackageRel) {
      return toJsOutput(byPackageRel);
    }
  }

  if (discovered.length === 1) {
    return toJsOutput(discovered[0]);
  }

  discovered.sort((a, b) => {
    const depthDiff = a.split(path.sep).length - b.split(path.sep).length;
    return depthDiff === 0 ? a.localeCompare(b) : depthDiff;
  });
  return toJsOutput(discovered[0]);
}

function resolveJsOutput(
  buildRoots: Array<string>,
  mode: BuildMode,
  project: MoonProjectConfig,
  preferredPackagePath?: string,
): JsOutput | undefined {
  const localBuildRoot = path.resolve(path.join(project.moduleRoot, '_build'));
  for (const buildRoot of buildRoots) {
    const metadata = readBuildMetadata(buildRoot);
    // Error-tolerant approach: if metadata is missing or malformed, we will
    // still attempt to find JS outputs in the build root, prioritizing the
    // local build root. This allows for some flexibility in build artifact
    // structures while still supporting the main package selection logic when
    // metadata is available. 
    // 
    // if (!metadata) {
    //   continue;
    // }
    const allowFallback = path.resolve(buildRoot) === localBuildRoot;
    const mainPkg = pickMainPackage(
      metadata,
      project.modPath,
      preferredPackagePath,
      allowFallback,
    );
    if (!mainPkg && !allowFallback) {
      continue;
    }
    const output = findJsOutputInBuildRoot(buildRoot, mode, project.modPath, mainPkg);
    if (output) {
      return output;
    }
  }
  return undefined;
}

function runMoonBuild(mode: BuildMode, cwd: string): void {
  const args = ['build', '--target', 'js', mode === 'release' ? '--release' : '--debug'];
  const result = spawnSync('moon', args, { cwd, encoding: 'utf8' });
  if (result.status === 0) {
    return;
  }
  if (result.error) {
    throw result.error;
  }
  throw new Error((result.stdout ?? '') + (result.stderr ?? ''));
}

function shouldRebuildForFile(filePath: string): boolean {
  const fileName = path.basename(filePath);
  return filePath.endsWith('.mbt')
    || filePath.endsWith('.mbti')
    || fileName === 'moon.work'
    || fileName === 'moon.mod'
    || fileName === 'moon.mod.json'
    || fileName === 'moon.pkg'
    || fileName === 'moon.pkg.json';
}

/**
 * Rabbita Vite plugin.
 *
 * Config:
 * - `main`:
 *   Optional relative package path for selecting the MoonBit main package
 *   (for example: `"main"` or `"app/web"`).
 *
 * Selection rule when `main` is not provided:
 * 1. Choose an `is-main` package whose `root` equals the module name from
 *    `moon.mod` or legacy `moon.mod.json`.
 * 2. Fallback to the first `is-main` package in build metadata.
 *
 * Entry behavior:
 * - Keeps `index.html` unchanged (still supports `/main.js`).
 * - Also accepts the real MoonBit output filename whose basename depends on
 *   the selected main package.
 */
export function rabbita(options: RabbitaOptions = {}): Plugin {
  const mainPackagePath = options.main;
  const explicitMoonModDir = options.moonModDir
    ? path.resolve(options.moonModDir)
    : undefined;
  let project: MoonProjectConfig | undefined = undefined;
  let isBuild = false;
  let latestOutput: JsOutput | undefined = undefined;
  let rebuildTimer: ReturnType<typeof setTimeout> | undefined = undefined;

  function ensureProject(root: string = defaultProjectRoot()): MoonProjectConfig {
    const moduleRoot = explicitMoonModDir ?? root;
    if (!project || project.moduleRoot !== moduleRoot) {
      project = probeMoonBitProject(moduleRoot);
    }
    return project;
  }

  function runMoonbitBuild(): JsOutput {
    const currentProject = project ?? ensureProject();
    const primaryMode: BuildMode = isBuild ? 'release' : 'debug';
    const buildRoots = buildRootCandidates(currentProject);
    runMoonBuild(primaryMode, currentProject.moduleRoot);

    let output = resolveJsOutput(buildRoots, primaryMode, currentProject, mainPackagePath);

    if (!output && primaryMode === 'release') {
      runMoonBuild('debug', currentProject.moduleRoot);
      output = resolveJsOutput(buildRoots, 'debug', currentProject, mainPackagePath);
    }

    if (!output) {
      throw new Error(
        `Cannot locate generated JS output under ${buildRoots.map(root => `"${root}"`).join(', ')}. `
        + 'Please verify your MoonBit main package and build artifacts.',
      );
    }

    latestOutput = output;
    return output;
  }

  function ensureOutput(): JsOutput {
    if (!latestOutput) {
      return runMoonbitBuild();
    }
    if (!fs.existsSync(latestOutput.jsPath)) {
      return runMoonbitBuild();
    }
    if (latestOutput.sourceMapPath && !fs.existsSync(latestOutput.sourceMapPath)) {
      return runMoonbitBuild();
    }
    return latestOutput;
  }

  function reportError(err: string, server: ViteDevServer): void {
    const errMsg = err.split('\n').slice(1).join('\n');
    server.ws.send({
      type: 'error',
      err: {
        message: errMsg,
        stack: '',
        id: 'rabbita-build',
        plugin: 'vite-plugin-rabbita',
      },
    });
  }

  function scheduleRebuild(server: ViteDevServer, filePath: string): void {
    if (!shouldRebuildForFile(filePath)) {
      return;
    }

    if (rebuildTimer) {
      clearTimeout(rebuildTimer);
    }

    rebuildTimer = setTimeout(() => {
      rebuildTimer = undefined;
      try {
        runMoonbitBuild();
        server.moduleGraph.invalidateAll();
        server.ws.send({ type: 'full-reload' });
      } catch (err: any) {
        reportError(err.toString(), server);
      }
    }, 10);
  }

  return {
    name: 'vite-plugin-rabbita',
    enforce: 'pre',

    config(_, { command }) {
      isBuild = command === 'build';
    },

    configResolved(config) {
      ensureProject(config.root);
    },

    buildStart() {
      try {
        if (project) {
          runMoonbitBuild();
        }
      } catch (err: any) {
        console.log('buildStart error', err);
      }
    },

    configureServer(server) {
      const currentProject = ensureProject(server.config.root);
      const watchTargets = [
        path.join(currentProject.moduleRoot, '**/*.mbt'),
        path.join(currentProject.moduleRoot, '**/*.mbti'),
        path.join(currentProject.moduleRoot, '**/moon.pkg'),
        path.join(currentProject.moduleRoot, '**/moon.pkg.json'),
        path.join(currentProject.moduleRoot, 'moon.mod'),
        path.join(currentProject.moduleRoot, 'moon.mod.json'),
      ];
      if (currentProject.workspaceRoot) {
        watchTargets.push(path.join(currentProject.workspaceRoot, 'moon.work'));
      }
      server.watcher.add(watchTargets);
      const onFsChange = (filePath: string) => {
        scheduleRebuild(server, filePath);
      };
      server.watcher.on('add', onFsChange);
      server.watcher.on('change', onFsChange);
      server.watcher.on('unlink', onFsChange);
    },

    resolveId(source) {
      const cleanSource = source.split('?', 1)[0];
      let entryFileName = latestOutput ? path.basename(latestOutput.jsPath) : undefined;
      if (cleanSource.endsWith('.js')) {
        try {
          const needsRefresh = !entryFileName
            || (entryFileName && cleanSource !== `/${entryFileName}` && cleanSource !== entryFileName);
          if (needsRefresh) {
            latestOutput = undefined;
          }
          entryFileName = path.basename(ensureOutput().jsPath);
        } catch {
          // buildStart will report build errors
        }
      }

      if (
        cleanSource === '/main.js'
        || cleanSource === 'main.js'
        || (entryFileName && (cleanSource === `/${entryFileName}` || cleanSource === entryFileName))
      ) {
        return VIRTUAL_MAIN_ENTRY_ID;
      }
      return null;
    },

    load(id) {
      if (id !== VIRTUAL_MAIN_ENTRY_ID) {
        return null;
      }

      const output = ensureOutput();
      const code = fs.readFileSync(output.jsPath, 'utf8')
        .replace(/\n?\/\/[#@]\s*sourceMappingURL=.*$/m, '')
        .replace(/\n?\/\*#\s*sourceMappingURL=.*?\*\//m, '');
      const map = output.sourceMapPath && fs.existsSync(output.sourceMapPath)
        ? JSON.parse(fs.readFileSync(output.sourceMapPath, 'utf8'))
        : null;
      return { code, map };
    },

    handleHotUpdate({ server, file, modules }) {
      if (!shouldRebuildForFile(file)) {
        return modules;
      }
      scheduleRebuild(server, file);
      return [];
    },
  };
}

export default rabbita;
