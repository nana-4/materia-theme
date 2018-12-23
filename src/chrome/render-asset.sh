#!/bin/bash
set -ueo pipefail

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

i="$1"

echo "Rendering '$i.png'"
if [[ -n "${RENDER_SVG}" ]] ; then
  "$RENDER_SVG" --dpi 96 "$i.svg" "$i.png"
else
  "$INKSCAPE" --export-dpi=96 --export-png="$i.png" "$i.svg" >/dev/null
fi

if [[ -n "${OPTIPNG}" ]] ; then
	"$OPTIPNG" -o7 --quiet "$i.png"
fi
