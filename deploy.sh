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
pnpm install

# Build all packages
echo ">>> pnpm build"
pnpm build

# Install CLI globally
echo ">>> Installing inkos CLI globally..."
cd packages/cli && npm install -g .
cd "$SCRIPT_DIR"

echo ""
echo "=== Build complete ==="
echo ""
echo "inkos CLI is now available globally."
echo "To start InkOS Studio:  inkos studio"
