import type { Plugin } from "@opencode-ai/plugin";

const testCommands = [
  "pytest",
  "npm test",
  "npm run test",
  "jest",
  "yarn test",
  "pnpm test",
  "python -m pytest",
  "python -m unittest",
];

export const setupDevHook: Plugin = async ({ $ }) => {
  return {
    "tool.execute.before": async (input) => {
      if (input.tool !== "bash") return;

      const command = input.args?.command as string | undefined;
      if (!command) return;

      const shouldRunSetup = testCommands.some((testCmd) =>
        command.includes(testCmd)
      );

      if (shouldRunSetup) {
        try {
          await $("[ -f ./scripts/setup-dev.sh ] && ./scripts/setup-dev.sh || true").quiet();
        } catch {
          // Setup script not found or failed - continue anyway
        }
      }
    },
  };
};
