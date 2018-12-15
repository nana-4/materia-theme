#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)"
INKSCAPE="$(command -v inkscape)"
OPTIPNG="$(command -v optipng)"

SRC_FILE="assets.svg"
ASSETS_DIR="assets"

i="$1"

echo "Rendering '$ASSETS_DIR/$i.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --export-id "$i" \
         "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  "$INKSCAPE" --export-id="$i" \
        --export-id-only \
        --export-png="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
fi
"$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"

echo "Rendering '$ASSETS_DIR/$i@2.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --export-id "$i" \
        --dpi 192 \
         "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  "$INKSCAPE" --export-id="$i" \
        --export-id-only \
        --export-dpi=192 \
        --export-png="$ASSETS_DIR/$i@2.png" "$SRC_FILE" >/dev/null
fi
"$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i@2.png"
