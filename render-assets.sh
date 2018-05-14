#!/bin/bash
set -ueo pipefail

if [[ ! "$(which inkscape 2> /dev/null)" ]]; then
  echo inkscape needs to be installed to generate the png.
  exit 1
fi

if [[ ! "$(which optipng 2> /dev/null)" ]]; then
  echo optipng needs to be installed to generate the png.
  exit 1
fi

gtk() (
  cd src/gtk
  rm assets/*.png || :
  ./render-assets.sh
)

gtk2_light() (
  cd src/gtk-2.0
  rm assets/*.png || :
  ./render-assets.sh light
)

gtk2_dark() (
  cd src/gtk-2.0
  rm assets-dark/*.png || :
  ./render-assets.sh dark
)

case "${1:-}" in
  "")
    gtk
    gtk2_light
    gtk2_dark
    ;;
  gtk)
    gtk
    ;;
  gtk2)
    gtk2_light
    gtk2_dark
    ;;
  gtk2-light)
    gtk2_light
    ;;
  gtk2-dark)
    gtk2_dark
    ;;
  *)
    echo "Unknown argument: '$1'"
    echo "Use 'gtk', 'gtk2', 'gtk2-light' or 'gtk2-dark' as an argument."
    ;;
esac
