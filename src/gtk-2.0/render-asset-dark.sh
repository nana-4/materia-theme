#! /bin/bash
set -ueo pipefail

RSVG_CONVERT="/usr/bin/rsvg-convert"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="assets-dark.svg"
ASSETS_DIR="assets-dark"

i=${1}

if [ -f $ASSETS_DIR/$i.png ]; then
    echo $ASSETS_DIR/$i.png exists.
else
    echo Rendering $ASSETS_DIR/$i.png
    $RSVG_CONVERT -i $i -o $ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png
fi

exit 0
