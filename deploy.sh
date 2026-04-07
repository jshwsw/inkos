#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== InkOS Deploy ==="

# Check Node.js version
NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  echo "Error: Node.js >= 20 required (current: $(node -v))"
  exit 1
fi

# Check pnpm
if ! command -v pnpm &> /dev/null; then
  echo "pnpm not found, installing via corepack..."
  corepack enable
  corepack prepare pnpm@latest --activate
fi

# Install dependencies
echo ">>> pnpm install"
pnpm install --frozen-lockfile

# Build all packages
echo ">>> pnpm build"
pnpm build

echo ""
echo "=== Build complete ==="
echo ""
echo "To start InkOS Studio:  cd packages/studio && node dist/api/index.js"
echo "To use CLI:             cd packages/cli && node dist/index.js"
