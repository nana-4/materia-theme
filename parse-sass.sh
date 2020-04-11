#!/bin/bash
set -ueo pipefail

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

echo "Generating the chrome-scrollbar CSS..."

sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar/scrollbars.{scss,css}
sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar-dark/scrollbars.{scss,css}
