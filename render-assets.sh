#!/bin/bash

if [ ! "$(which inkscape 2> /dev/null)" ]; then
  echo inkscape needs to be installed to generate the png.
  exit 1
fi

if [ ! "$(which optipng 2> /dev/null)" ]; then
  echo optipng needs to be installed to generate the png.
  exit 1
fi

gtk3() (
  cd src/gtk-3.0/gtk-common
  rm assets/*.png
  ./render-assets.sh
)

gtk2_light() (
  cd src/gtk-2.0
  rm assets/*.png
  ./render-assets.sh
)

gtk2_dark() (
  cd src/gtk-2.0
  rm assets-dark/*.png
  ./render-assets-dark.sh
)

case "${1}" in
  "")
    gtk3
    gtk2_light
    gtk2_dark
    ;;
  gtk3)
    gtk3
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
    echo "Unknown argument: '${1}'"
    echo "Use 'gtk3', 'gtk2', 'gtk2-light' or 'gtk2-dark' as an argument."
    ;;
esac
