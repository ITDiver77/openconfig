#!/bin/bash
set -e

CONFIG_DIR="${HOME}/.config/opencode"

echo "Installing OpenCode universal config to ${CONFIG_DIR}..."

mkdir -p "${CONFIG_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ln -nsf "${REPO_ROOT}/opencode.json" "${CONFIG_DIR}/opencode.json"
ln -nsf "${REPO_ROOT}/AGENTS.md" "${CONFIG_DIR}/AGENTS.md"
ln -nsf "${REPO_ROOT}/CLAUDE.md" "${CONFIG_DIR}/CLAUDE.md"
ln -nsf "${REPO_ROOT}/GLOBAL_WORKFLOW.md" "${CONFIG_DIR}/GLOBAL_WORKFLOW.md"
ln -nsf "${REPO_ROOT}/context.md" "${CONFIG_DIR}/context.md"
ln -nsf "${REPO_ROOT}/product.md" "${CONFIG_DIR}/product.md"
ln -nsf "${REPO_ROOT}/todo.md" "${CONFIG_DIR}/todo.md"
ln -nsf "${REPO_ROOT}/changelog.md" "${CONFIG_DIR}/changelog.md"
ln -nsf "${REPO_ROOT}/agents" "${CONFIG_DIR}/agents"
ln -nsf "${REPO_ROOT}/skills" "${CONFIG_DIR}/skills"
ln -nsf "${REPO_ROOT}/plugins" "${CONFIG_DIR}/plugins"
ln -nsf "${REPO_ROOT}/configs" "${CONFIG_DIR}/configs"

echo ""
echo "✓ Global install complete!"
echo ""
echo "Files symlinked:"
echo "  - opencode.json"
echo "  - AGENTS.md"
echo "  - CLAUDE.md"
echo "  - GLOBAL_WORKFLOW.md"
echo "  - context.md"
echo "  - product.md"
echo "  - todo.md"
echo "  - changelog.md"
echo "  - agents/"
echo "  - skills/"
echo "  - plugins/"
echo "  - configs/"
echo ""
echo "Restart OpenCode to apply changes."
