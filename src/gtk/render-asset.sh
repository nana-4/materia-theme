#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

if "$INKSCAPE" --help | grep -e "--export-filename" > /dev/null; then
  EXPORT_FILE_OPTION="--export-filename"
elif "$INKSCAPE" --help | grep -e "--export-file" > /dev/null; then
  EXPORT_FILE_OPTION="--export-file"
elif "$INKSCAPE" --help | grep -e "--export-png" > /dev/null; then
  EXPORT_FILE_OPTION="--export-png"
fi

SRC_FILE="assets.svg"
ASSETS_DIR="assets"

i="$1"

echo "Rendering '$ASSETS_DIR/$i.png'"
if [[ -n "${RENDER_SVG}" ]]; then
  "$RENDER_SVG" --export-id "$i" \
                "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  "$INKSCAPE" --export-id="$i" \
              --export-id-only \
              "$EXPORT_FILE_OPTION"="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
fi
if [[ -n "${OPTIPNG}" ]]; then
  "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
fi

echo "Rendering '$ASSETS_DIR/$i@2.png'"
if [[ -n "${RENDER_SVG}" ]]; then
  # @TODO: remove --zoom when it will be fixed/implemented in resvg
  "$RENDER_SVG" --export-id "$i" \
                --dpi 192 \
                --zoom 2 \
                "$SRC_FILE" "$ASSETS_DIR/$i@2.png"
else
  "$INKSCAPE" --export-id="$i" \
              --export-id-only \
              --export-dpi=192 \
              "$EXPORT_FILE_OPTION"="$ASSETS_DIR/$i@2.png" "$SRC_FILE" >/dev/null
fi
if [[ -n "${OPTIPNG}" ]]; then
  "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i@2.png"
fi
