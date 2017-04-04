#!/bin/sh

for color in '' '-dark' '-light' ; do
	sassc -t expanded src/gtk-3.0/3.18/gtk${color}.{scss,css}

	for size in '' '-compact' ; do
		for version in '3.20' '3.22' ; do
			sassc -t expanded src/gtk-3.0/${version}/gtk${color}${size}.{scss,css}
		done

		# This gnome-shell theme can skip versions '3.20' & '2.22'
		for version in '3.18' '3.24' ; do
			sassc -t expanded src/gnome-shell/${version}/gnome-shell${color}${size}.{scss,css}
		done
	done
done
