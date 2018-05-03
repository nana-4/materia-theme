#! /bin/bash
set -ueo pipefail

INKSCAPE="$(which inkscape)"
OPTIPNG="$(which optipng)"

SRC_FILE="assets-dark.svg"
ASSETS_DIR="assets-dark"

i=${1}

GTK2_HIDPI=$(echo ${GTK2_HIDPI-False} | tr '[:upper:]' '[:lower:]')
if [[ ${GTK2_HIDPI} == "true" ]] ; then
	EXTRA_OPTIONS="--export-dpi=192"
else
	EXTRA_OPTIONS=""
fi

if [ -f $ASSETS_DIR/$i.png ]; then
    echo $ASSETS_DIR/$i.png exists.
else
    echo Rendering $ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-background-opacity=0 \
              $EXTRA_OPTIONS \
              --export-png=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png
fi

exit 0
