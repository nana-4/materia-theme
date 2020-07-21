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

i="$1"

echo "Rendering '$i.png'"
if [[ -n "${RENDER_SVG}" ]]; then
  "$RENDER_SVG" --dpi 96 "$i.svg" "$i.png"
else
  "$INKSCAPE" --export-dpi=96 "$EXPORT_FILE_OPTION"="$i.png" "$i.svg" >/dev/null
fi

if [[ -n "${OPTIPNG}" ]]; then
  "$OPTIPNG" -o7 --quiet "$i.png"
fi
