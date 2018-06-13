#!/bin/bash
set -ueo pipefail

INKSCAPE="$(which inkscape)"
OPTIPNG="$(which optipng)"

SRC_FILE="assets.svg"
ASSETS_DIR="assets"

i="$1"

echo "Rendering '$ASSETS_DIR/$i.png'"
"$INKSCAPE" --export-id="$i" \
            --export-id-only \
            --export-png="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null \
&& "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"

echo "Rendering '$ASSETS_DIR/$i@2.png'"
"$INKSCAPE" --export-id="$i" \
            --export-id-only \
            --export-dpi=192 \
            --export-png="$ASSETS_DIR/$i@2.png" "$SRC_FILE" >/dev/null \
&& "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i@2.png"
