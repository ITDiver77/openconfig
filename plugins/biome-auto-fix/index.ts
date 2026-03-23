import type { Plugin } from "@opencode-ai/plugin";

export const biomeAutoFix: Plugin = async ({ $ }) => {
  return {
    "tool.execute.after": async (input) => {
      if (input.tool === "edit" || input.tool === "write") {
        const filePath = input.args?.filePath as string | undefined;
        if (!filePath) return;

        const jsExtensions = [".js", ".jsx", ".ts", ".tsx", ".json", ".jsonc"];
        const ext = jsExtensions.find((e) => filePath.endsWith(e));

        if (ext) {
          try {
            await $(`biome check --apply "${filePath}"`).quiet();
            await $(`biome format --write "${filePath}"`).quiet();
          } catch {
            // Silently handle - linting issues reported via diagnostics
          }
        }
      }
    },
  };
};
