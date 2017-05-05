#!/bin/bash

if [ ! "$(which sassc 2> /dev/null)" ]; then
  echo sassc needs to be installed to generate the css.
  exit 1
fi

SASSC_OPT="-M -t expanded"

echo Generating the css...

for color in '' '-dark' '-light' ; do
  sassc $SASSC_OPT src/gtk-3.0/3.18/gtk${color}.{scss,css}

  for size in '' '-compact' ; do
    for version in '3.20' '3.22' ; do
      sassc $SASSC_OPT src/gtk-3.0/${version}/gtk${color}${size}.{scss,css}
    done

    # This gnome-shell theme can skip versions '3.20' & '2.22'
    for version in '3.18' '3.24' ; do
      sassc $SASSC_OPT src/gnome-shell/${version}/gnome-shell${color}${size}.{scss,css}
    done
  done
done
