#!/bin/bash
set -ueo pipefail
#set -x

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$REPO_DIR/src"

DEST_DIR="/usr/share/themes"
THEME_NAME="Materia"
COLOR_VARIANTS=('' '-dark' '-light')
SIZE_VARIANTS=('' '-compact')

GTK_VERSIONS=('3.0')

if [[ -z "${GS_VERSION:-}" ]]; then
  # Set a proper gnome-shell theme version
  if [[ "$(command -v gnome-shell)" ]]; then
    CURRENT_GS_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -2)"
    MAJOR_VER="$(echo "$CURRENT_GS_VERSION" | cut -d . -f 1)"
    MINOR_VER="$(echo "$CURRENT_GS_VERSION" | cut -d . -f 2)"

    if (( "$MINOR_VER" % 2 == 0 )); then
      GS_VERSION="$MAJOR_VER.$MINOR_VER"
    else
      GS_VERSION="$MAJOR_VER.$(($MINOR_VER + 1))"
    fi
  else
    echo "'gnome-shell' not found, using styles for last gnome-shell version available."
    GS_VERSION="3.36"
  fi
fi

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)
  -c, --color VARIANT...  Specify color variant(s) [standard|dark|light] (Default: All variants)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)
  -g, --gdm               Install and apply GDM theme (for advanced users)
                          See also: src/gnome-shell/README.md
  -h, --help              Show help

INSTALLATION EXAMPLES:
Install all theme variants into ~/.themes
  $0 --dest ~/.themes
Install all theme variants including GDM theme
  $0 --gdm
Install standard theme variant only
  $0 --color standard --size standard
Install specific theme variants with different name into ~/.themes
  $0 --dest ~/.themes --name MyTheme --color light dark --size compact
EOF
}

install() {
  local dest="$1"
  local name="$2$3$4"
  local color="$3"
  local size="$4"

  if [[ "$color" == '' ]]; then
    local scss_dark_theme="false"
    local scss_light_topbar="false"
  elif [[ "$color" == '-light' ]]; then
    local scss_dark_theme="false"
    local scss_light_topbar="true"
  elif [[ "$color" == '-dark' ]]; then
    local scss_dark_theme="true"
    local scss_light_topbar="false"
  fi

  if [[ "$size" == '' ]]; then
    local scss_compact="false"
  elif [[ "$size" == '-compact' ]]; then
    local scss_compact="true"
  fi

  [[ "$color" == '-dark' ]] && local ELSE_DARK="$color"
  [[ "$color" == '-light' ]] && local ELSE_LIGHT="$color"

  local THEME_DIR="$dest/$name"

  # SC2115: Protect /.
  [[ -d "$THEME_DIR" ]] && rm -rf "${THEME_DIR:?}"

  echo "Installing '$THEME_DIR'..."

  mkdir -p                                                                      "$THEME_DIR"
  cp -r "$REPO_DIR/COPYING"                                                     "$THEME_DIR"
  sed \
    -e "s/@theme_name@/$name/g" \
    "$SRC_DIR/index.theme.in" > "$THEME_DIR/index.theme"

  mkdir -p                                                                      "$THEME_DIR/chrome"
  cp -r "$SRC_DIR/chrome/chrome-theme$color.crx"                                "$THEME_DIR/chrome/chrome-theme.crx"
  cp -r "$SRC_DIR/chrome/chrome-scrollbar${ELSE_DARK:-}.crx"                    "$THEME_DIR/chrome/chrome-scrollbar.crx"

  mkdir -p                                                                      "$THEME_DIR/cinnamon"
  cp -r "$SRC_DIR/cinnamon/assets"                                              "$THEME_DIR/cinnamon"
  cp -r "$SRC_DIR/cinnamon/thumbnail.png"                                       "$THEME_DIR/cinnamon"
  sed \
    -e "s/@dark_theme@/$scss_dark_theme/g" \
    -e "s/@light_topbar@/$scss_light_topbar/g" \
    -e "s/@compact@/$scss_compact/g" \
    "$SRC_DIR/cinnamon/cinnamon.scss.in" > "$SRC_DIR/cinnamon/cinnamon.$name.scss"
  sassc "${SASSC_OPT[@]}" "$SRC_DIR/cinnamon/cinnamon.$name.scss"               "$THEME_DIR/cinnamon/cinnamon.css"

  mkdir -p                                                                      "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/"{*.svg,extensions,noise-texture.png,pad-osd.css} "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/gnome-shell-theme.gresource.xml"                  "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/icons"                                            "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/README.md"                                        "$THEME_DIR/gnome-shell"
  cp -r "$SRC_DIR/gnome-shell/assets${ELSE_DARK:-}"                             "$THEME_DIR/gnome-shell/assets"
  sed \
    -e "s/@dark_theme@/$scss_dark_theme/g" \
    -e "s/@light_topbar@/$scss_light_topbar/g" \
    -e "s/@compact@/$scss_compact/g" \
    -e "s/@version@/$GS_VERSION/g" \
    "$SRC_DIR/gnome-shell/gnome-shell.scss.in" > "$SRC_DIR/gnome-shell/gnome-shell.$name.scss"
  sassc "${SASSC_OPT[@]}" "$SRC_DIR/gnome-shell/gnome-shell.$name.scss"         "$THEME_DIR/gnome-shell/gnome-shell.css"

  mkdir -p                                                                      "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/"{apps.rc,hacks.rc,main.rc}                           "$THEME_DIR/gtk-2.0"
  cp -r "$SRC_DIR/gtk-2.0/assets${ELSE_DARK:-}"                                 "$THEME_DIR/gtk-2.0/assets"
  cp -r "$SRC_DIR/gtk-2.0/gtkrc$color"                                          "$THEME_DIR/gtk-2.0/gtkrc"

  cp -r "$SRC_DIR/gtk/assets"                                                   "$THEME_DIR/gtk-assets"
  cp -r "$SRC_DIR/gtk/icons"                                                    "$THEME_DIR/gtk-icons"

  local GTK_VARIANTS=('')
  [[ "$color" != '-dark' ]] && local GTK_VARIANTS+=('-dark')

  for version in "${GTK_VERSIONS[@]}"; do
    mkdir -p                                                                    "$THEME_DIR/gtk-$version"
    ln -s ../gtk-assets                                                         "$THEME_DIR/gtk-$version/assets"
    ln -s ../gtk-icons                                                          "$THEME_DIR/gtk-$version/icons"

    for variant in "${GTK_VARIANTS[@]}"; do
      sed \
        -e "s/@dark_theme@/$scss_dark_theme/g" \
        -e "s/@light_topbar@/$scss_light_topbar/g" \
        -e "s/@compact@/$scss_compact/g" \
        "$SRC_DIR/gtk/gtk$variant.scss.in" > "$SRC_DIR/gtk/gtk$variant.gtk-$version.$name.scss"
      sassc "${SASSC_OPT[@]}" "$SRC_DIR/gtk/gtk$variant.gtk-$version.$name.scss" "$THEME_DIR/gtk-$version/gtk$variant.css"
    done
  done

  mkdir -p                                                                      "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/"{assets,metacity-theme-3.xml}                     "$THEME_DIR/metacity-1"
  cp -r "$SRC_DIR/metacity-1/metacity-theme-2$color.xml"                        "$THEME_DIR/metacity-1/metacity-theme-2.xml"

  mkdir -p                                                                      "$THEME_DIR/plank"
  cp -r "$SRC_DIR/plank/dock.theme"                                             "$THEME_DIR/plank"

  mkdir -p                                                                      "$THEME_DIR/unity"
  cp -rT "$SRC_DIR/unity/dash-buttons"                                          "$THEME_DIR/unity"
  cp -r  "$SRC_DIR/unity/dash-widgets.json"                                     "$THEME_DIR/unity"
  cp -rT "$SRC_DIR/unity/launcher"                                              "$THEME_DIR/unity"
  cp -rT "$SRC_DIR/unity/window-buttons${ELSE_LIGHT:-}"                         "$THEME_DIR/unity"

  cp -r "$SRC_DIR/xfwm4/xfwm4$color"                                            "$THEME_DIR/xfwm4"
}

# Bakup and install files related to GDM theme
install_gdm() {
  local THEME_DIR="$1/$2$3$4"
  local GS_THEME_FILE="/usr/share/gnome-shell/gnome-shell-theme.gresource"
  local UBUNTU_THEME_FILE="/usr/share/gnome-shell/theme/ubuntu.css"

  if [[ -f "$GS_THEME_FILE" ]] && command -v glib-compile-resources >/dev/null; then
    echo "Installing '$GS_THEME_FILE'..."
    cp -an "$GS_THEME_FILE" "$GS_THEME_FILE.bak"
    glib-compile-resources \
      --sourcedir="$THEME_DIR/gnome-shell" \
      --target="$GS_THEME_FILE" \
      "$THEME_DIR/gnome-shell/gnome-shell-theme.gresource.xml"
  else
    echo
    echo "ERROR: Failed to install '$GS_THEME_FILE'"
    exit 1
  fi

  if [[ -f "$UBUNTU_THEME_FILE" ]]; then
    echo "Installing '$UBUNTU_THEME_FILE'..."
    cp -an "$UBUNTU_THEME_FILE" "$UBUNTU_THEME_FILE.bak"
    cp -af "$THEME_DIR/gnome-shell/gnome-shell.css" "$UBUNTU_THEME_FILE"
  fi
}

colors=()
sizes=()
while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      _name="$2"
      shift 2
      ;;
    -g|--gdm)
      gdm='true'
      shift 1
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -s|--size)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            sizes+=("${SIZE_VARIANTS[0]}")
            shift
            ;;
          compact)
            sizes+=("${SIZE_VARIANTS[1]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized size variant '${1:-}'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '${1:-}'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ ! -w "${dest:-$DEST_DIR}" ]]; then
  echo "Please run as root."
  exit 1
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi
if [[ "${#sizes[@]}" -eq 0 ]] ; then
  sizes=("${SIZE_VARIANTS[@]}")
fi
for color in "${colors[@]}"; do
  for size in "${sizes[@]}"; do
    install "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$color" "$size"
  done
done

if [[ "${gdm:-}" == 'true' ]]; then
  install_gdm "${dest:-$DEST_DIR}" "${_name:-$THEME_NAME}" "$color" "$size"
fi

echo
echo "Done."
