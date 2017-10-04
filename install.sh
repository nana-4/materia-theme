#!/bin/bash
set -ueo pipefail
#set -x

repodir=$(cd $(dirname $0) && pwd)
srcdir=${repodir}/src

themedir_base_fallback=${destdir:-}/usr/share/themes/Flat-Plat
themedir_base=${THEME_DIR_BASE:-$themedir_base_fallback}

if [[ $(which gnome-shell 2> /dev/null) ]]; then
  gnomever_major=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 1)
  gnomever_minor=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 2)

  if [ -e ${srcdir}/gnome-shell/$gnomever_major.$gnomever_minor ]; then
    gnomever=$gnomever_major.$gnomever_minor
  elif [ -e ${srcdir}/gnome-shell/$gnomever_major.$(($gnomever_minor + 1)) ]; then
    gnomever=$gnomever_major.$(($gnomever_minor + 1))
  elif [ -e ${srcdir}/gnome-shell/$gnomever_major.$(($gnomever_minor - 1)) ]; then
    gnomever=$gnomever_major.$(($gnomever_minor - 1))
  else
    gnomever=3.18
  fi
else
  gnomever=3.18
fi

_COLOR_VARIANTS=(
  ''
  '-dark'
  '-light'
)
if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

_SIZE_VARIANTS=(
  ''
  '-compact'
)
if [ ! -z "${SIZE_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

echo

for color in "${_COLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    echo Installing Flat-Plat${color}${size} ...

    themedir=${themedir_base}${color}${size}
    if [[ -d ${themedir} ]]; then
      rm -r ${themedir}
    fi
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
      "Flat-Plat${color} Theme.crx" \
      ${themedir}/chrome
    if [ "$color" != '-dark' ]; then
      cp -ur \
        "Flat-Plat Scrollbars.crx" \
        ${themedir}/chrome
    else
      cp -ur \
        "Flat-Plat${color} Scrollbars.crx" \
        ${themedir}/chrome
    fi

    # Install GNOME Shell Theme
    install -d ${themedir}/gnome-shell
    cd ${srcdir}/gnome-shell/${gnomever}
    cp -ur \
      *.svg \
      ${themedir}/gnome-shell
    cp -urL \
      extensions \
      pad-osd.css \
      ${themedir}/gnome-shell
    if [ "$color" != '-dark' ]; then
      cp -urL \
        assets \
        ${themedir}/gnome-shell
    else
      cp -urL \
        assets${color} \
        ${themedir}/gnome-shell/assets
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
      hacks.rc \
      main.rc \
      ${themedir}/gtk-2.0
    if [ "$color" != '-dark' ]; then
      cp -ur \
        assets \
        ${themedir}/gtk-2.0
    else
      cp -ur \
        assets${color} \
        ${themedir}/gtk-2.0/assets
    fi
    cp -ur \
      gtkrc${color} \
      ${themedir}/gtk-2.0/gtkrc

    # Install GTK+ 3 Theme
    install -d ${themedir}/gtk-common
    cd ${srcdir}/gtk-3.0/gtk-common
    cp -ur \
      assets \
      ${themedir}/gtk-common

    for version in '3.18' '3.20' '3.22'; do
      if [ "$version" == '3.18' ]; then
        install -d ${themedir}/gtk-3.0
        cd ${srcdir}/gtk-3.0/${version}
        cp -ur \
          assets \
          ${themedir}/gtk-3.0
        cp -ur \
          gtk${color}.css \
          ${themedir}/gtk-3.0/gtk.css
        if [ "$color" != '-dark' ] && [ -f gtk-dark.css ]; then
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
        if [ "$color" != '-dark' ] && [ -f gtk-dark.css ]; then
          cp -ur \
            gtk-dark${size}.css \
            ${themedir}/gtk-${version}/gtk-dark.css
        fi
      fi
    done

    # Install Metacity Theme
    install -d ${themedir}/metacity-1
    cd ${srcdir}/metacity-1
    cp -ur \
      *.svg \
      ${themedir}/metacity-1
    if [ "$color" != '-light' ]; then
      cp -ur \
        metacity-theme-2.xml \
        metacity-theme-3.xml \
        ${themedir}/metacity-1
    else
      cp -ur \
        metacity-theme-2${color}.xml \
        ${themedir}/metacity-1/metacity-theme-2.xml
      cp -ur \
        metacity-theme-3${color}.xml \
        ${themedir}/metacity-1/metacity-theme-3.xml
    fi

    # Install Unity Theme
    install -d ${themedir}/unity
    cd ${srcdir}/unity
    cp -ur \
      *.svg \
      *.png \
      *.json \
      ${themedir}/unity
    if [ "$color" != '-light' ]; then
      cp -ur \
        buttons \
        ${themedir}/unity
    else
      cp -urT \
        buttons${color} \
        ${themedir}/unity/buttons
    fi

    # Install Xfwm Theme
    install -d ${themedir}/xfwm4
    cd ${srcdir}/xfwm4
    cp -ur \
      *.svg \
      themerc \
      ${themedir}/xfwm4
    if [ "$color" != '-light' ]; then
      cp -ur \
        assets \
        ${themedir}/xfwm4
    else
      cp -urT \
        assets${color} \
        ${themedir}/xfwm4/assets
    fi
  done
done

echo
echo Done.

# vim: set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab:
