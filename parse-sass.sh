#!/usr/bin/env bash
set -ueo pipefail

if [[ ! "$(command -v sass)" ]]; then
  echo "'sass' needs to be installed to generate the CSS."
  exit 1
fi

SASS_OPT=('--no-source-map')

echo "Generating the chrome-scrollbar CSS..."

sass "${SASS_OPT[@]}" src/chrome/chrome-scrollbar/scrollbars.{scss,css}
sass "${SASS_OPT[@]}" src/chrome/chrome-scrollbar-dark/scrollbars.{scss,css}
