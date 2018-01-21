#! /bin/bash
set -ueo pipefail

INDEX="assets.txt"
SRC_FILE="assets-dark.svg"

_parallel() {
  which parallel && parallel $@ || (
    while read i; do
      $1 $i
    done
  )
}

GTK2_HIDPI=$(echo ${GTK2_HIDPI-False} | tr '[:upper:]' '[:lower:]')
if [[ ${GTK2_HIDPI} == "true" ]] ; then
  sed -i.bak -e '1s/width="200"/width="400"/' -e '1s/height="480"/height="960"/' $SRC_FILE
fi

cat $INDEX | _parallel ./render-asset-dark.sh

if [[ ${GTK2_HIDPI} == "true" ]] ; then
  mv $SRC_FILE{.bak,}
fi

exit 0
