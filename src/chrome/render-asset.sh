#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)"
OPTIPNG="$(command -v optipng)"

i="$1"

echo "Rendering '$i.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --dpi 96 "$i.svg" "$i.png"
else
  "$INKSCAPE" --export-dpi=96 --export-png="$i.png" "$i.svg" >/dev/null
fi

"$OPTIPNG" -o7 --quiet "$i.png"
