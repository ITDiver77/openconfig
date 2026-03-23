import type { Plugin } from "@opencode-ai/plugin";

export const ruffAutoFix: Plugin = async ({ $ }) => {
  return {
    "tool.execute.after": async (input) => {
      if (input.tool === "edit" || input.tool === "write") {
        const filePath = input.args?.filePath as string | undefined;
        if (!filePath) return;

        if (filePath.endsWith(".py")) {
          try {
            await $(`ruff check --fix "${filePath}"`).quiet();
            await $(`ruff format "${filePath}"`).quiet();
          } catch {
            // Silently handle - linting issues reported via diagnostics
          }
        }
      }
    },
  };
};
