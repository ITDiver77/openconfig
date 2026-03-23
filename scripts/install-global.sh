#!/bin/bash
set -e

CONFIG_DIR="${HOME}/.config/opencode"

echo "Installing OpenCode universal config to ${CONFIG_DIR}..."

mkdir -p "${CONFIG_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ln -sf "${REPO_ROOT}/opencode.json" "${CONFIG_DIR}/opencode.json"
ln -sf "${REPO_ROOT}/AGENTS.md" "${CONFIG_DIR}/AGENTS.md"
ln -sf "${REPO_ROOT}/CLAUDE.md" "${CONFIG_DIR}/CLAUDE.md"
ln -sf "${REPO_ROOT}/GLOBAL_WORKFLOW.md" "${CONFIG_DIR}/GLOBAL_WORKFLOW.md"
ln -sf "${REPO_ROOT}/agents" "${CONFIG_DIR}/agents"
ln -sf "${REPO_ROOT}/skills" "${CONFIG_DIR}/skills"
ln -sf "${REPO_ROOT}/plugins" "${CONFIG_DIR}/plugins"
ln -sf "${REPO_ROOT}/configs" "${CONFIG_DIR}/configs"

echo ""
echo "✓ Global install complete!"
echo ""
echo "Files symlinked:"
echo "  - opencode.json"
echo "  - AGENTS.md"
echo "  - GLOBAL_WORKFLOW.md"
echo "  - agents/"
echo "  - skills/"
echo "  - plugins/"
echo "  - configs/"
echo ""
echo "Restart OpenCode to apply changes."
