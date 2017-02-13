#!/bin/bash

gnomever=$(/sbin/ldconfig -v -N 2>/dev/null | grep -oE 'libgtk-3\.so\.0\.([[:digit:]]{1,2})00' | sed 's|libgtk-3\.so\.0\.\([[:digit:]]\{1,2\}\)00|3.\1|')
repodir=$(cd $(dirname $0) && pwd)
srcdir=${repodir}/src

# FIXME:
if [ -z "$gnomever" ] ; then
	gnomever=3.18
fi

echo

# Not enabled color: '-dark'
for color in '' '-light' ; do
	for size in '' '-compact' ; do
		echo Installing Flat-Plat${color}${size} ...

		themedir=${destdir}/usr/share/themes/Flat-Plat${color}${size}
		install -d ${themedir}

		# Copy COPYING
		cd ${repodir}
		cp -ur \
			COPYING \
			${themedir}

		# Install index.theme
		cd ${srcdir}
		cp -ur \
			index${color}${size}.theme \
			${themedir}/index.theme

		# Install Chrome Theme/Extention
		install -d ${themedir}/chrome
		cd ${srcdir}/chrome
		cp -ur \
			"Flat-Plat Scrollbars.crx" \
			"Flat-Plat${color} Theme.crx" \
			${themedir}/chrome

		# Install GNOME Shell Theme
		install -d ${themedir}/gnome-shell
		cd ${srcdir}/gnome-shell/${gnomever}
		cp -ur \
			extensions \
			no-events.svg \
			no-notifications.svg \
			process-working.svg \
			${themedir}/gnome-shell
		if [ "$color" == '-dark' ] ; then
			cp -ur \
				assets${color} \
				${themedir}/gnome-shell/assets
		else
			cp -ur \
				assets \
				${themedir}/gnome-shell
		fi
		cp -ur \
			gnome-shell${color}${size}.css \
			${themedir}/gnome-shell/gnome-shell.css
		glib-compile-resources \
			--sourcedir=${themedir}/gnome-shell \
			--target=${themedir}/gnome-shell/gnome-shell-theme.gresource \
			gnome-shell-theme.gresource.xml

		# Install GTK+ 2 Theme
		install -d ${themedir}/gtk-2.0
		cd ${srcdir}/gtk-2.0
		cp -ur \
			apps.rc \
			main.rc \
			${themedir}/gtk-2.0
		if [ "$color" == '-dark' ] ; then
			cp -ur \
				assets${color} \
				${themedir}/gtk-2.0/assets
		else
			cp -ur \
				assets \
				${themedir}/gtk-2.0
		fi
		cp -ur \
			gtkrc${color} \
			${themedir}/gtk-2.0/gtkrc

		# Install GTK+ 3 Theme
		for version in '3.18' '3.20' '3.22' ; do
			if [ "$version" == '3.18' ] ; then
				install -d ${themedir}/gtk-3.0
				cd ${srcdir}/gtk-3.0/${version}
				cp -ur \
					assets \
					${themedir}/gtk-3.0
				cp -ur \
					gtk${color}.css \
					${themedir}/gtk-3.0/gtk.css
				if [ "$color" == '-dark' ] ; then
					:
				else
					cp -ur \
						gtk-dark.css \
						${themedir}/gtk-3.0
				fi
			else
				install -d ${themedir}/gtk-${version}
				cd ${srcdir}/gtk-3.0/${version}
				cp -ur \
					assets \
					${themedir}/gtk-${version}
				cp -ur \
					gtk${color}${size}.css \
					${themedir}/gtk-${version}/gtk.css
				if [ "$color" == '-dark' ] ; then
					:
				else
					cp -ur \
						gtk-dark${size}.css \
						${themedir}/gtk-${version}/gtk-dark.css
				fi
			fi
		done

		install -d ${themedir}/gtk-common
		cd ${srcdir}/gtk-3.0/gtk-common
		cp -ur \
			assets \
			${themedir}/gtk-common

		# Install Metacity Theme
		install -d ${themedir}/metacity-1
		cd ${srcdir}/metacity-1
		cp -ur \
			*.svg \
			${themedir}/metacity-1
		if [ "$color" == '-light' ] ; then
			cp -ur \
				metacity-theme-2${color}.xml \
				${themedir}/metacity-1/metacity-theme-2.xml
			cp -ur \
				metacity-theme-3${color}.xml \
				${themedir}/metacity-1/metacity-theme-3.xml
		else
			cp -ur \
				metacity-theme-2.xml \
				metacity-theme-3.xml \
				${themedir}/metacity-1
		fi

		# Install Unity Theme
		install -d ${themedir}/unity
		cd ${srcdir}/unity
		cp -ur \
			*.svg \
			*.png \
			*.json \
			${themedir}/unity
		if [ "$color" == '-light' ] ; then
			cp -urT \
				buttons${color} \
				${themedir}/unity/buttons
		else
			cp -ur \
				buttons \
				${themedir}/unity
		fi
	done
done

echo
echo Done.
