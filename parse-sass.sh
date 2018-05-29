#!/bin/bash
set -ueo pipefail

if [[ ! "$(which sassc 2> /dev/null)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-dark' '-light')
_SIZE_VARIANTS=('' '-compact')

GTK_VERSIONS=('3.18' '3.20' '3.22')
GS_VERSIONS=('3.18' '3.24' '3.26' '3.28')

if [[ ! -z "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [[ ! -z "${SIZE_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

echo "== Generating the CSS..."

for color in "${_COLOR_VARIANTS[@]}"; do
  # The '-compact' variant is not supported for gtk '3.18'
  sassc "${SASSC_OPT[@]}" "src/gtk/$GTK_VERSIONS/gtk$color."{scss,css}

  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/cinnamon/cinnamon$color$size."{scss,css}
    for version in "${GTK_VERSIONS[@]:1}"; do
      sassc "${SASSC_OPT[@]}" "src/gtk/$version/gtk$color$size."{scss,css}
    done

    # This gnome-shell theme can skip versions '3.20' & '2.22'
    for version in "${GS_VERSIONS[@]}"; do
      sassc "${SASSC_OPT[@]}" "src/gnome-shell/$version/gnome-shell$color$size."{scss,css}
    done
  done
done

sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar/scrollbars.{scss,css}
sassc "${SASSC_OPT[@]}" src/chrome/chrome-scrollbar-dark/scrollbars.{scss,css}
