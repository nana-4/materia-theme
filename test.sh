#!/bin/bash
#
# Once run the script, no need to run ./install.sh for testing. ;)
# Without an argument, this will install only normal variant.
# Valid arguments are:
#
#   compact dark dark-compact light light-compact all uninstall
#
# FIXME: `unity` and `xfwm4` are not fully supported for now since `*.svg` link incorrect locales (with '-light' variant).
# FIXME: Multiple arguments should be allowed.

REPO_DIR=$(cd $(dirname $0) && pwd)
SRC_PATH=${REPO_DIR}/src

DEST_DIR=~/.themes
THEME_NAME=Materia.dev
COLOR_VARIANTS=('' '-dark' '-light')
SIZE_VARIANTS=('' '-compact')

GTK_VERSIONS=('3.18' '3.20' '3.22')
GS_VERSIONS=('3.18' '3.20' '3.22' '3.24' '3.26')
LATEST_GS_VERSION=${GS_VERSIONS[@]: -1}

# Set a proper gnome-shell theme version
if [[ $(which gnome-shell 2> /dev/null) ]]; then
  CURRENT_GS_VERSION=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -2)
  for version in "${GS_VERSIONS[@]}"; do
    if (( $(echo "$CURRENT_GS_VERSION <= $version" | bc) )); then
      GS_VERSION=${version}
      break
    elif (( $(echo "$CURRENT_GS_VERSION > $LATEST_GS_VERSION" | bc) )); then
      GS_VERSION=${LATEST_GS_VERSION}
      break
    fi
  done
else
  GS_VERSION=${LATEST_GS_VERSION}
fi

test() {
  local color=${1}
  local size=${2}

  [[ ${color} == '-dark' ]] && local ELSE_DARK=${color}
  [[ ${color} == '-light' ]] && local ELSE_LIGHT=${color}

  local THEME_DIR=${DEST_DIR}/${THEME_NAME}${color}${size}

  mkdir -p                                                                        ${THEME_DIR}
  ln -sfT ${SRC_PATH}/index${color}${size}.theme                                  ${THEME_DIR}/index.theme

  mkdir -p                                                                        ${THEME_DIR}/gnome-shell
  ln -sf  ${SRC_PATH}/gnome-shell/${GS_VERSION}/{extensions,pad-osd.css}          ${THEME_DIR}/gnome-shell
  ln -sfT ${SRC_PATH}/gnome-shell/${GS_VERSION}/assets${ELSE_DARK}                ${THEME_DIR}/gnome-shell/assets
  ln -sfT ${SRC_PATH}/gnome-shell/${GS_VERSION}/gnome-shell${color}${size}.css    ${THEME_DIR}/gnome-shell/gnome-shell.css

  mkdir -p                                                                        ${THEME_DIR}/gtk-2.0
  ln -sf  ${SRC_PATH}/gtk-2.0/{apps.rc,hacks.rc,main.rc}                          ${THEME_DIR}/gtk-2.0
  ln -sfT ${SRC_PATH}/gtk-2.0/assets${ELSE_DARK}                                  ${THEME_DIR}/gtk-2.0/assets
  ln -sfT ${SRC_PATH}/gtk-2.0/gtkrc${color}                                       ${THEME_DIR}/gtk-2.0/gtkrc

  mkdir -p                                                                        ${THEME_DIR}/gtk-common
  ln -sf  ${SRC_PATH}/gtk-3.0/gtk-common/assets                                   ${THEME_DIR}/gtk-common

  for version in "${GTK_VERSIONS[@]}"; do
    if [[ ${version} == '3.18' ]]; then
      mkdir -p                                                                    ${THEME_DIR}/gtk-3.0
      ln -sf  ${SRC_PATH}/gtk-3.0/${version}/assets                               ${THEME_DIR}/gtk-3.0
      ln -sfT ${SRC_PATH}/gtk-3.0/${version}/gtk${color}.css                      ${THEME_DIR}/gtk-3.0/gtk.css
      [[ ${color} != '-dark' ]] && \
      ln -sfT ${SRC_PATH}/gtk-3.0/${version}/gtk-dark.css                         ${THEME_DIR}/gtk-3.0/gtk-dark.css
    else
      mkdir -p                                                                    ${THEME_DIR}/gtk-${version}
      ln -sf  ${SRC_PATH}/gtk-3.0/${version}/assets                               ${THEME_DIR}/gtk-${version}
      ln -sfT ${SRC_PATH}/gtk-3.0/${version}/gtk${color}${size}.css               ${THEME_DIR}/gtk-${version}/gtk.css
      [[ ${color} != '-dark' ]] && \
      ln -sfT ${SRC_PATH}/gtk-3.0/${version}/gtk-dark${size}.css                  ${THEME_DIR}/gtk-${version}/gtk-dark.css
    fi
  done

  mkdir -p                                                                        ${THEME_DIR}/metacity-1
  ln -sf  ${SRC_PATH}/metacity-1/assets                                           ${THEME_DIR}/metacity-1
  ln -sfT ${SRC_PATH}/metacity-1/metacity-theme-2${ELSE_LIGHT}.xml                ${THEME_DIR}/metacity-1/metacity-theme-2.xml
  ln -sfT ${SRC_PATH}/metacity-1/metacity-theme-3${ELSE_LIGHT}.xml                ${THEME_DIR}/metacity-1/metacity-theme-3.xml

  mkdir -p                                                                        ${THEME_DIR}/unity
  ln -sf  ${SRC_PATH}/unity/{*.svg,*.png,dash-widgets.json}                       ${THEME_DIR}/unity
  ln -sfT ${SRC_PATH}/unity/assets${ELSE_LIGHT}                                   ${THEME_DIR}/unity/assets

  mkdir -p                                                                        ${THEME_DIR}/xfwm4
  ln -sf  ${SRC_PATH}/xfwm4/{*.svg,themerc}                                       ${THEME_DIR}/xfwm4
  ln -sfT ${SRC_PATH}/xfwm4/assets${ELSE_LIGHT}                                   ${THEME_DIR}/xfwm4/assets

  echo Installed to ${THEME_DIR}
}

case "${1}" in
  "")
    test '' ''
    ;;
  compact)
    test '' '-compact'
    ;;
  dark)
    test '-dark' ''
    ;;
  dark-compact)
    test '-dark' '-compact'
    ;;
  light)
    test '-light' ''
    ;;
  light-compact)
    test '-light' '-compact'
    ;;
  all)
    test '' ''
    test '' '-compact'
    test '-dark' ''
    test '-dark' '-compact'
    test '-light' ''
    test '-light' '-compact'
    ;;
  uninstall)
    rm -rf ${DEST_DIR}/${THEME_NAME}{,-compact,-dark,-dark-compact,-light,-light-compact}
    ;;
  *)
    echo "Invalid argument: ${1}"
    echo "Valid arguments are: compact dark dark-compact light light-compact all uninstall"
    ;;
esac
