#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)"
INKSCAPE="$(command -v inkscape)"
OPTIPNG="$(command -v optipng)"

i="$1"
GTK2_HIDPI="$(echo "${GTK2_HIDPI-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${GTK2_HIDPI}" == "true" ]] ; then
  DPI=192
else
  DPI=96
fi

echo "Rendering '$i.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --dpi ${DPI} "$i.svg" "$i.png"
else
  "$INKSCAPE" --export-dpi=${DPI} --export-png="$i.png" "$i.svg" >/dev/null
fi

"$OPTIPNG" -o7 --quiet "$i.png"
