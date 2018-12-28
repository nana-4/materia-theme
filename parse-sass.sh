#!/bin/bash
set -ueo pipefail

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-dark' '-light')
_SIZE_VARIANTS=('' '-compact')

GTK_VERSIONS=('3.0')
GS_VERSIONS=('3.18' '3.24' '3.26' '3.28' '3.30')

if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [[ -n "${SIZE_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

echo "== Generating the CSS..."

for color in "${_COLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    for version in "${GTK_VERSIONS[@]}"; do
      sassc "${SASSC_OPT[@]}" "src/gtk/$version/gtk$color$size."{scss,css}
    done

    for version in "${GS_VERSIONS[@]}"; do
      sassc "${SASSC_OPT[@]}" "src/gnome-shell/$version/gnome-shell$color$size."{scss,css}
    done

    sassc "${SASSC_OPT[@]}" "src/cinnamon/cinnamon$color$size."{scss,css}
  done
done

sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar/scrollbars.{scss,css}
sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar-dark/scrollbars.{scss,css}
