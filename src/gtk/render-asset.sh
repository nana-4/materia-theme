#! /bin/bash
set -ueo pipefail

RSVG_CONVERT="/usr/bin/rsvg-convert"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="assets.svg"
SRC_FILE_2="assets@2.svg"
ASSETS_DIR="assets"

i=${1}

if [ -f $ASSETS_DIR/$i.png ]; then
    echo $ASSETS_DIR/$i.png exists.
else
    echo Rendering $ASSETS_DIR/$i.png
    $RSVG_CONVERT -i $i -o $ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png
fi
if [ -f $ASSETS_DIR/$i@2.png ]; then
    echo $ASSETS_DIR/$i@2.png exists.
else
    echo Rendering $ASSETS_DIR/$i@2.png
    $RSVG_CONVERT -i $i -o $ASSETS_DIR/$i@2.png $SRC_FILE_2 >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i@2.png
fi

exit 0
