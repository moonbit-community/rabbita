import { mkdir, readFile, writeFile } from "node:fs/promises";
import { minify } from "terser";

const input =
  "_build/js/release/build/benchmark/rabbita-js-framework-benchmark/main/main.js";
const output = "dist/main.js";

const source = await readFile(input, "utf8");
const result = await minify(source, {
  compress: { passes: 2, toplevel: true },
  mangle: { toplevel: true },
  module: true,
});

if (!result.code) {
  throw new Error("terser produced no JavaScript output");
}

await mkdir("dist", { recursive: true });
await writeFile(output, result.code);
