#!/bin/bash
#
# Once run the script, no need to run ./install.sh for testing. ;)
#
# NOTE: This is WIP and incomplete. Polish me with PRs!
# FIXME: Multiple arguments should be allowed.

REPO_DIR=$(cd $(dirname $0) && pwd)
SRC_PATH=${REPO_DIR}/src

THEME_NAME=Materia.dev
THEMES_DIR=~/.themes

GNOME_VERSION=3.24
GTK_VERSION=3.22

test() {
  [[ ${color} == '-dark' ]] && ELSE_DARK=${color}
  [[ ${color} == '-light' ]] && ELSE_LIGHT=${color}

  THEME_DIR=${THEMES_DIR}/${THEME_NAME}${color}${size}

  mkdir -p                                                                        ${THEME_DIR}
  ln -sfT ${SRC_PATH}/index${color}${size}.theme                                  ${THEME_DIR}/index.theme

  mkdir -p                                                                        ${THEME_DIR}/gnome-shell
  ln -sfT ${SRC_PATH}/gnome-shell/${GNOME_VERSION}/assets${ELSE_DARK}             ${THEME_DIR}/gnome-shell/assets
  ln -sfT ${SRC_PATH}/gnome-shell/${GNOME_VERSION}/extensions                     ${THEME_DIR}/gnome-shell/extensions
  ln -sfT ${SRC_PATH}/gnome-shell/${GNOME_VERSION}/gnome-shell${color}${size}.css ${THEME_DIR}/gnome-shell/gnome-shell.css
# ln -sfT ${SRC_PATH}/gnome-shell/${GNOME_VERSION}/pad-osd.css                    ${THEME_DIR}/gnome-shell/pad-osd.css

  mkdir -p                                                                        ${THEME_DIR}/gtk-2.0
  ln -sfT ${SRC_PATH}/gtk-2.0/assets${ELSE_DARK}                                  ${THEME_DIR}/gtk-2.0/assets
  ln -sfT ${SRC_PATH}/gtk-2.0/gtkrc${color}                                       ${THEME_DIR}/gtk-2.0/gtkrc
  ln -sfT ${SRC_PATH}/gtk-2.0/apps.rc                                             ${THEME_DIR}/gtk-2.0/apps.rc
  ln -sfT ${SRC_PATH}/gtk-2.0/hacks.rc                                            ${THEME_DIR}/gtk-2.0/hacks.rc
  ln -sfT ${SRC_PATH}/gtk-2.0/main.rc                                             ${THEME_DIR}/gtk-2.0/main.rc

  mkdir -p                                                                        ${THEME_DIR}/gtk-3.0
  ln -sfT ${SRC_PATH}/gtk-3.0/gtk-common/assets                                   ${THEME_DIR}/gtk-3.0/assets
  ln -sfT ${SRC_PATH}/gtk-3.0/${GTK_VERSION}/gtk${color}${size}.css               ${THEME_DIR}/gtk-3.0/gtk.css
  ln -sfT ${SRC_PATH}/gtk-3.0/${GTK_VERSION}/gtk-dark${size}.css                  ${THEME_DIR}/gtk-3.0/gtk-dark.css

  mkdir -p                                                                        ${THEME_DIR}/metacity-1
  ln -sfT ${SRC_PATH}/metacity-1/assets                                           ${THEME_DIR}/metacity-1/assets
  ln -sfT ${SRC_PATH}/metacity-1/metacity-theme-2${ELSE_LIGHT}.xml                ${THEME_DIR}/metacity-1/metacity-theme-2.xml
  ln -sfT ${SRC_PATH}/metacity-1/metacity-theme-3${ELSE_LIGHT}.xml                ${THEME_DIR}/metacity-1/metacity-theme-3.xml

  mkdir -p                                                                        ${THEME_DIR}/unity
  ln -sfT ${SRC_PATH}/unity/buttons${ELSE_LIGHT}                                  ${THEME_DIR}/unity/buttons
# ln -sfT ${SRC_PATH}/unity/*.svg                                                 ${THEME_DIR}/unity/*.svg
  ln -sfT ${SRC_PATH}/unity/launcher_bfb.png                                      ${THEME_DIR}/unity/launcher_bfb.png
  ln -sfT ${SRC_PATH}/unity/dash-widgets.json                                     ${THEME_DIR}/unity/dash-widgets.json

  mkdir -p                                                                        ${THEME_DIR}/xfwm4
  ln -sfT ${SRC_PATH}/xfwm4/assets${ELSE_LIGHT}                                   ${THEME_DIR}/xfwm4/assets
# ln -sfT ${SRC_PATH}/xfwm4/*.svg                                                 ${THEME_DIR}/xfwm4/*.svg
  ln -sfT ${SRC_PATH}/xfwm4/themerc                                               ${THEME_DIR}/xfwm4/themerc

  echo Installed to ${THEME_DIR}
}

case "${1}" in
  "")
    color=''
    size=''
    test
    ;;
  compact)
    color=''
    size='-compact'
    test
    ;;
  dark)
    color='-dark'
    size=''
    test
    ;;
  dark-compact)
    color='-dark'
    size='-compact'
    test
    ;;
  light)
    color='-light'
    size=''
    test
    ;;
  light-compact)
    color='-light'
    size='-compact'
    test
    ;;
  uninstall)
    rm -rf ${THEMES_DIR}/${THEME_NAME}{,-compact,-dark,-dark-compact,-light,-light-compact}
    ;;
  *)
    echo "Unknown argument: '${1}'"
    echo "Use 'compact', 'dark', 'dark-compact', 'light', 'light-compact' or 'uninstall' as an argument."
    ;;
esac
