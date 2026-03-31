#!/bin/bash
# Claude Code Private Edition - Installer
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${1:-$HOME/.local}"
BIN_DIR="${PREFIX}/bin"

echo "=== Claude Code - Private Edition ==="
echo ""
echo "Installing to: ${BIN_DIR}/"

mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/claude-notelemetry" "$BIN_DIR/claude-notelemetry"
cp "$SCRIPT_DIR/claude-private" "$BIN_DIR/claude-private"
chmod +x "$BIN_DIR/claude-notelemetry" "$BIN_DIR/claude-private"

echo "Installed."
echo ""
echo "Usage:  claude-private"
echo ""
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "Add to PATH: export PATH=\"$BIN_DIR:\$PATH\""
fi
