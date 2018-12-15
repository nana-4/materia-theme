#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)"
INKSCAPE="$(command -v inkscape)"
OPTIPNG="$(command -v optipng)"

if [[ "$1" == "dark" ]]; then
  SRC_FILE="assets-dark.svg"
  ASSETS_DIR="assets-dark"
else
  SRC_FILE="assets.svg"
  ASSETS_DIR="assets"
fi

i="$2"

GTK2_HIDPI="$(echo "${GTK2_HIDPI-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${GTK2_HIDPI}" == "true" ]] ; then
  DPI=192
else
  DPI=96
fi

echo "Rendering '$ASSETS_DIR/$i.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --export-id "$i" \
        --dpi ${DPI} \
         "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  "$INKSCAPE" --export-id="$i" \
        --export-id-only \
        --export-dpi=${DPI} \
        --export-png="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
fi

"$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
