#!/bin/bash
set -ueo pipefail

INKSCAPE="$(which inkscape)"
OPTIPNG="$(which optipng)"

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
  EXTRA_OPTIONS=("--export-dpi=192")
else
  EXTRA_OPTIONS=()
fi

echo "Rendering '$ASSETS_DIR/$i.png'"
"$INKSCAPE" --export-id="$i" \
            --export-id-only \
            ${EXTRA_OPTIONS+"${EXTRA_OPTIONS[@]}"} \
            --export-png="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null \
&& "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
