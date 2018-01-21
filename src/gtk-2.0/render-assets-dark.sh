#! /bin/bash
set -ueo pipefail

INDEX="assets.txt"

_parallel() {
  which parallel && parallel $@ || (
    while read i; do
      $1 $i
    done
  )
}

cat $INDEX | _parallel ./render-asset-dark.sh
exit 0
