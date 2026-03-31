#!/bin/bash
# Creates a self-extracting .run installer
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="$SCRIPT_DIR/claude-private-2.1.88.run"

echo "Creating self-extracting installer..."

cat > "$OUTPUT" << 'HEADER'
#!/bin/bash
# Claude Code - Private Edition v2.1.88
# Self-extracting installer — no telemetry build
#
# Usage: chmod +x claude-private-2.1.88.run && ./claude-private-2.1.88.run

set -e

PREFIX="$HOME/.local"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix|--prefix=*) [[ "$1" == *=* ]] && PREFIX="${1#*=}" || { PREFIX="$2"; shift; }; shift ;;
        --help|-h) echo "Usage: $0 [--prefix /path]  (default: ~/.local)"; exit 0 ;;
        *) shift ;;
    esac
done

echo "=== Claude Code - Private Edition v2.1.88 ==="
echo "Installing to: ${PREFIX}/bin/"

ARCHIVE_LINE=$(awk '/^__ARCHIVE_MARKER__$/{print NR + 1; exit 0; }' "$0")
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

tail -n +"$ARCHIVE_LINE" "$0" | tar xz -C "$TMPDIR"

mkdir -p "${PREFIX}/bin"
cp "$TMPDIR/claude-notelemetry" "${PREFIX}/bin/claude-notelemetry"
cp "$TMPDIR/claude-private" "${PREFIX}/bin/claude-private"
chmod +x "${PREFIX}/bin/claude-notelemetry" "${PREFIX}/bin/claude-private"

echo ""
echo "Installed. Usage: claude-private"
echo ""
if ! echo "$PATH" | grep -q "${PREFIX}/bin"; then
    echo "Add to PATH:"
    echo "  echo 'export PATH=\"${PREFIX}/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
fi
exit 0

__ARCHIVE_MARKER__
HEADER

tar czf - -C "$SCRIPT_DIR" claude-notelemetry claude-private >> "$OUTPUT"
chmod +x "$OUTPUT"

SIZE=$(du -h "$OUTPUT" | cut -f1)
echo "Created: $OUTPUT ($SIZE)"
