#!/bin/sh

gnomever=$(echo $(gnome-shell --version) | cut -d ' ' -f 3 | cut -d . -f -2)
srcdir=$(cd $(dirname $0)/../src && pwd)
themedir=/usr/share/themes/Flat-Plat-light

install -d ${themedir}


# Copy COPYING
cd $(cd $(dirname $0)/.. && pwd)
cp -ur \
	COPYING \
	${themedir}


# Install index.theme
cd ${srcdir}
cp -ur \
	index-light.theme \
	${themedir}/index.theme


# Install Chrome Theme/Extention
install -d ${themedir}/chrome
cd ${srcdir}/chrome
cp -ur \
	"Flat-Plat Scrollbars.crx" \
	"Flat-Plat-light Theme.crx" \
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
cp -ur \
	assets \
	${themedir}/gnome-shell
cp -ur \
	gnome-shell-light.css \
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
cp -ur \
	assets \
	${themedir}/gtk-2.0
cp -ur \
	gtkrc-light \
	${themedir}/gtk-2.0/gtkrc


# Install GTK+ 3 Theme
install -d ${themedir}/gtk-3.0
cd ${srcdir}/gtk-3.0/3.18
cp -ur \
	assets \
	${themedir}/gtk-3.0
cp -ur \
	gtk-light.css \
	${themedir}/gtk-3.0/gtk.css
cp -ur \
	gtk-dark.css \
	${themedir}/gtk-3.0


install -d ${themedir}/gtk-3.20
cd ${srcdir}/gtk-3.0/3.20
cp -ur \
	assets \
	${themedir}/gtk-3.20
cp -ur \
	gtk-light.css \
	${themedir}/gtk-3.20/gtk.css
cp -ur \
	gtk-dark.css \
	${themedir}/gtk-3.20


install -d ${themedir}/gtk-3.22
cd ${srcdir}/gtk-3.0/3.22
cp -ur \
	assets \
	${themedir}/gtk-3.22
cp -ur \
	gtk-light.css \
	${themedir}/gtk-3.22/gtk.css
cp -ur \
	gtk-dark.css \
	${themedir}/gtk-3.22


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
cp -ur \
	metacity-theme-2-light.xml \
	${themedir}/metacity-1/metacity-theme-2.xml
cp -ur \
	metacity-theme-3-light.xml \
	${themedir}/metacity-1/metacity-theme-3.xml


# Install Unity Theme
install -d ${themedir}/unity
cd ${srcdir}/unity
cp -ur \
	*.svg \
	*.png \
	*.json \
	${themedir}/unity
cp -urT \
	buttons-light \
	${themedir}/unity/buttons
