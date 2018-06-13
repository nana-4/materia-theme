#!/bin/bash
set -ueo pipefail

INKSCAPE="$(which inkscape)"
OPTIPNG="$(which optipng)"

i="$1"

echo "Rendering '$i.png'"
"$INKSCAPE" --export-png="$i.png" "$i.svg" >/dev/null \
&& "$OPTIPNG" -o7 --quiet "$i.png"
