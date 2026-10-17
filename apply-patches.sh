#!/usr/bin/env bash
# Apply Omarchy patches onto a fresh clone of 68proxy
set -e
if [ ! -f "package.json" ]; then
  echo "Run this inside the cloned 68proxy repo root"
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/omarchy"
cp "$SCRIPT_DIR/tauri.conf.json" src-tauri/tauri.conf.json
echo "Patched tauri.conf.json for Linux"
cp "$SCRIPT_DIR/../68proxy.desktop" ./68proxy.desktop
echo "Added desktop entry"
echo "Done. Now run: pnpm install && pnpm tauri build"
