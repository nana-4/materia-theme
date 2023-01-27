#!/usr/bin/env bash
# shellcheck disable=SC1090
#set -x
set -ueo pipefail

SRC_PATH="$(readlink -f "$(dirname "$0")")"

darker() {
    "$SRC_PATH/scripts/darker.sh" "$@"
}
mix() {
    "$SRC_PATH/scripts/mix.sh" "$@"
}
is_dark() {
    hexinput="$(tr '[:lower:]' '[:upper:]' <<< "$1")"
    half_darker="$(darker "$hexinput" 88)"
    [[ "$half_darker" == "000000" ]]
}


print_usage() {
    echo "usage: $0 [-t TARGET_DIR] [-o OUTPUT_THEME_NAME] [-p PATH_LIST] PATH_TO_PRESET"
    echo "examples:"
    # shellcheck disable=SC2028 # This is meant to be usage text.
    echo "       $0 -o my-theme-name <(echo -e \"ROUNDNESS=0\\nBG=d8d8d8\\nFG=101010\\nHDR_BG=3c3c3c\\nHDR_FG=e6e6e6\\nSEL_BG=ad7fa8\\nMATERIA_VIEW=ffffff\\nMATERIA_SURFACE=f5f5f5\\nMATERIA_STYLE_COMPACT=True\\n\")"
    echo "       $0 -t ~/.themes ../colors/retro/twg"
    echo "       $0 --hidpi True ../colors/retro/clearlooks"
    exit 1
}


while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -p|--path-list)
            CUSTOM_PATHLIST="$2"
            shift
            ;;
        -t|--target)
            TARGET_DIR="$2"
            shift
            ;;
        -o|--output)
            OUTPUT_THEME_NAME="$2"
            shift
            ;;
        -d|--hidpi)
            OPTION_GTK2_HIDPI="$2"
            shift
            ;;
        -i|--inkscape)
            OPTION_FORCE_INKSCAPE="$2"
            shift
            ;;
        *)
            if [[ "$1" == -* ]] || [[ "${THEME-}" ]]; then
                echo "unknown option $1"
                print_usage
                exit 2
            fi
            THEME="$1"
            ;;
    esac
    shift
done

if [[ -z "${THEME:-}" ]]; then
    print_usage
fi

PATHLIST=(
    './src/_theme-color.scss'
    './src/chrome'
    './src/cinnamon'
    './src/cinnamon/assets'
    './src/gnome-shell'
    './src/gtk-2.0/assets.svg'
    './src/gtk-2.0/assets-dark.svg'
    './src/gtk-2.0/gtkrc'
    './src/gtk-2.0/gtkrc-dark'
    './src/gtk-2.0/gtkrc-light'
    './src/gtk-3.0/assets.svg'
    './src/metacity-1'
    './src/unity'
    './src/xfwm4'
    './src/qt5ct_palette.conf'
    './src/qt6ct_palette.conf'
)
if [[ -n "${CUSTOM_PATHLIST:-}" ]]; then
    IFS=', ' read -r -a PATHLIST <<< "${CUSTOM_PATHLIST:-}"
fi

EXPORT_QT5CT=0
EXPORT_QT6CT=0
for FILEPATH in "${PATHLIST[@]}"; do
    if [[ "$FILEPATH" == *qt5ct* ]]; then
        EXPORT_QT5CT=1
    elif [[ ${FILEPATH} == *qt6ct* ]] ;then
        EXPORT_QT6CT=1
    fi
done

OPTION_GTK2_HIDPI=$(tr '[:upper:]' '[:lower:]' <<< "${OPTION_GTK2_HIDPI-False}")
OPTION_FORCE_INKSCAPE=$(tr '[:upper:]' '[:lower:]' <<< "${OPTION_FORCE_INKSCAPE-True}")


if [[ "$THEME" == */* ]] || [[ "$THEME" == *.* ]]; then
    source "$THEME"
    THEME=$(basename "$THEME")
else
    if [[ -f "$SRC_PATH/../colors/$THEME" ]]; then
        source "$SRC_PATH/../colors/$THEME"
    else
        echo "Theme '$THEME' not found"
        exit 1
    fi
fi
if [[ $(date +"%m%d") = "0401" ]] && grep -q "no-jokes" <<< "$*"; then
    echo -e "\\n\\nError patching uxtheme.dll\\n\\n"
    BG=C0C0C0 MATERIA_SURFACE=C0C0C0 FG=000000 MATERIA_PANEL_OPACITY=1
    HDR_BG=C0C0C0 HDR_FG=000000 SEL_BG=000080 MATERIA_VIEW=FFFFFF
fi

# Migration:
HDR_BG=${HDR_BG-$MENU_BG}
HDR_FG=${HDR_FG-$MENU_FG}
MATERIA_VIEW=${MATERIA_VIEW-$TXT_BG}
MATERIA_SURFACE=${MATERIA_SURFACE-$BTN_BG}
GNOME_SHELL_PANEL_OPACITY=${GNOME_SHELL_PANEL_OPACITY-0.6}
MATERIA_PANEL_OPACITY=${MATERIA_PANEL_OPACITY-$GNOME_SHELL_PANEL_OPACITY}

MATERIA_STYLE_COMPACT=$(tr '[:upper:]' '[:lower:]' <<< "${MATERIA_STYLE_COMPACT-False}")
MATERIA_COLOR_VARIANT=$(tr '[:upper:]' '[:lower:]' <<< "${MATERIA_COLOR_VARIANT:-}")

SPACING=${SPACING-3}
ROUNDNESS=${ROUNDNESS-4}
# shellcheck disable=SC2034 # will this be used in the future?
ROUNDNESS_GTK2_HIDPI=$(( ROUNDNESS * 2 ))
MATERIA_PANEL_OPACITY=${MATERIA_PANEL_OPACITY-0.6}
MATERIA_SELECTION_OPACITY=${MATERIA_SELECTION_OPACITY-0.32}

INACTIVE_FG=$(mix "$FG" "$BG" 0.75)
INACTIVE_MATERIA_VIEW=$(mix "$MATERIA_VIEW" "$BG" 0.60)

TERMINAL_COLOR4=${TERMINAL_COLOR4:-1E88E5}
TERMINAL_COLOR5=${TERMINAL_COLOR5:-E040FB}
TERMINAL_COLOR9=${TERMINAL_COLOR9:-DD2C00}
TERMINAL_COLOR10=${TERMINAL_COLOR10:-00C853}
TERMINAL_COLOR11=${TERMINAL_COLOR11:-FF6D00}
TERMINAL_COLOR12=${TERMINAL_COLOR12:-66BB6A}

TARGET_DIR=${TARGET_DIR-$HOME/.themes}
OUTPUT_THEME_NAME=${OUTPUT_THEME_NAME-oomox-$THEME}
DEST_PATH="$TARGET_DIR/${OUTPUT_THEME_NAME/\//-}"

if [[ "$SRC_PATH" == "$DEST_PATH" ]]; then
    echo "can't do that"
    exit 1
fi


tempdir=$(mktemp -d)
post_clean_up() {
    rm -r "$tempdir" || :
}
trap post_clean_up EXIT SIGHUP SIGINT SIGTERM
cp -r "$SRC_PATH/"* "$tempdir/"
cd "$tempdir"


# autodetection which color variant to use
if [[ -z "$MATERIA_COLOR_VARIANT" ]]; then
    if is_dark "$BG"; then
        echo "== Dark background color detected. Setting color variant to dark."
        MATERIA_COLOR_VARIANT="dark"
    elif is_dark "$HDR_BG"; then
        echo "== Dark headerbar background color detected. Setting color variant to default."
        MATERIA_COLOR_VARIANT="default"
    else
        echo "== Light background color detected. Setting color variant to light."
        MATERIA_COLOR_VARIANT="light"
    fi
fi


echo "== Converting theme into template..."

for FILEPATH in "${PATHLIST[@]}"; do
    if [[ "$MATERIA_COLOR_VARIANT"  != "dark" ]]; then
        find "$FILEPATH" -type f -not -name '_color-palette.scss' -exec sed -i'' \
            -e '/color-surface/{n;s/#ffffff/%MATERIA_SURFACE%/g}' \
            -e '/color-base/{n;s/#ffffff/%MATERIA_VIEW%/g}' \
            -e 's/#8ab4f8/%SEL_BG%/g' \
            -e 's/#1967d2/%SEL_BG%/g' \
            -e 's/#000000/%FG%/g' \
            -e 's/#212121/%FG%/g' \
            -e 's/#f9f9f9/%BG%/g' \
            -e 's/#ffffff/%MATERIA_SURFACE%/g' \
            -e 's/#ffffff/%MATERIA_VIEW%/g' \
            -e 's/#424242/%HDR_BG%/g' \
            -e 's/#303030/%HDR_BG2%/g' \
            -e 's/#ffffff/%HDR_FG%/g' \
            -e 's/#c1c1c1/%INACTIVE_FG%/g' \
            -e 's/#f0f0f0/%HDR_BG%/g' \
            -e 's/#ebebeb/%HDR_BG2%/g' \
            -e 's/#1d1d1d/%HDR_FG%/g' \
            -e 's/#565656/%INACTIVE_FG%/g' \
            -e 's/Materia/%OUTPUT_THEME_NAME%/g' \
            {} \; ;
            else
                find "$FILEPATH" -type f -not -name '_color-palette.scss' -exec sed -i'' \
                    -e 's/#8ab4f8/%SEL_BG%/g' \
                    -e 's/#ffffff/%FG%/g' \
                    -e 's/#eeeeee/%FG%/g' \
                    -e 's/#121212/%BG%/g' \
                    -e 's/#2e2e2e/%MATERIA_SURFACE%/g' \
                    -e 's/#1e1e1e/%MATERIA_VIEW%/g' \
                    -e 's/#272727/%HDR_BG%/g' \
                    -e 's/#1e1e1e/%HDR_BG2%/g' \
                    -e 's/#e4e4e4/%HDR_FG%/g' \
                    -e 's/#a7a7a7/%INACTIVE_FG%/g' \
                    -e 's/Materia/%OUTPUT_THEME_NAME%/g' \
                    {} \; ;
    fi
done

#Not implemented yet:
#-e 's/%SPACING%/'"$SPACING"'/g' \

# shellcheck disable=SC2016
sed -i -e 's/^$corner-radius: .px/$corner-radius: '"$ROUNDNESS"'px/g' ./src/_theme.scss

if [[ "${DEBUG:-}" ]]; then
    echo "You can debug TEMP DIR: $tempdir, press [Enter] when finished"; read -r
fi

mv ./src/_theme-color.template.scss ./src/_theme-color.scss

echo "== Filling the template with the new colorscheme..."
for FILEPATH in "${PATHLIST[@]}"; do
    find "$FILEPATH" -type f -exec sed -i'' \
        -e 's/%BG%/#'"$BG"'/g' \
        -e 's/%BG2%/#'"$(darker $BG)"'/g' \
        -e 's/%FG%/#'"$FG"'/g' \
        -e 's/%TXT_BG%/#'"$TXT_BG"'/g' \
		-e 's/%TXT_FG%/#'"$TXT_FG"'/g' \
        -e 's/%SEL_BG%/#'"$SEL_BG"'/g' \
        -e 's/%SEL_BG2%/#'"$(darker $SEL_BG -20)"'/g' \
        -e 's/%SEL_FG%/#'"$SEL_FG"'/g' \
        -e 's/%MATERIA_VIEW%/#'"$MATERIA_VIEW"'/g' \
        -e 's/%HDR_BG%/#'"$HDR_BG"'/g' \
        -e 's/%HDR_BG2%/#'"$(darker $HDR_BG 10)"'/g' \
        -e 's/%HDR_BG3%/#'"$(darker $HDR_BG 20)"'/g' \
        -e 's/%HDR_FG%/#'"$HDR_FG"'/g' \
        -e 's/%MATERIA_SURFACE%/#'"$MATERIA_SURFACE"'/g' \
        -e 's/%SPACING%/'"$SPACING"'/g' \
        -e 's/%INACTIVE_FG%/#'"$INACTIVE_FG"'/g' \
        -e 's/%INACTIVE_MATERIA_VIEW%/#'"$INACTIVE_MATERIA_VIEW"'/g' \
        -e 's/%TERMINAL_COLOR4%/#'"$TERMINAL_COLOR4"'/g' \
        -e 's/%TERMINAL_COLOR5%/#'"$TERMINAL_COLOR5"'/g' \
        -e 's/%TERMINAL_COLOR9%/#'"$TERMINAL_COLOR9"'/g' \
        -e 's/%TERMINAL_COLOR10%/#'"$TERMINAL_COLOR10"'/g' \
        -e 's/%TERMINAL_COLOR11%/#'"$TERMINAL_COLOR11"'/g' \
        -e 's/%TERMINAL_COLOR12%/#'"$TERMINAL_COLOR12"'/g' \
        -e 's/%MATERIA_SELECTION_OPACITY%/'"$MATERIA_SELECTION_OPACITY"'/g' \
        -e 's/%MATERIA_PANEL_OPACITY%/'"$MATERIA_PANEL_OPACITY"'/g' \
        -e 's/%OUTPUT_THEME_NAME%/'"$OUTPUT_THEME_NAME"'/g' \
        {} \; ;
        done

        if [[ "$MATERIA_COLOR_VARIANT" == "default" ]]; then
            COLOR_VARIANT="default"
            COLOR_SUFFIX=""
        fi
        if [[ "$MATERIA_COLOR_VARIANT" == "light" ]]; then
            COLOR_VARIANT="light"
            COLOR_SUFFIX="-light"
        fi
        if [[ "$MATERIA_COLOR_VARIANT" == "dark" ]]; then
            COLOR_VARIANT="dark"
            COLOR_SUFFIX="-dark"
        fi
        if [[ "$OPTION_GTK2_HIDPI" == "true" ]]; then
            mv ./src/gtk-2.0/main.rc.hidpi ./src/gtk-2.0/main.rc
        fi

        if [[ "$EXPORT_QT5CT" = 1 ]]; then
            config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
            qt5ct_colors_dir="$config_home/qt5ct/colors/"
            test -d "$qt5ct_colors_dir" || mkdir -p "$qt5ct_colors_dir"
            mv ./src/qt5ct_palette.conf "$qt5ct_colors_dir/$OUTPUT_THEME_NAME.conf"
        fi

        if [[ "$EXPORT_QT6CT" = 1 ]]; then
            config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
            qt6ct_colors_dir="$config_home/qt6ct/colors/"
            test -d "$qt6ct_colors_dir" || mkdir -p "$qt6ct_colors_dir"
            mv ./src/qt6ct_palette.conf "$qt6ct_colors_dir/$OUTPUT_THEME_NAME.conf"
        fi

        if [[ "$MATERIA_STYLE_COMPACT" == "true" ]]; then
            SIZE_VARIANT="compact"
            SIZE_SUFFIX="-compact"
        else
            SIZE_VARIANT="default"
            SIZE_SUFFIX=""
        fi

# NOTE we use the functions we already have in render-assets.sh
echo "== Rendering GTK 2 assets..."
if [[ "$MATERIA_COLOR_VARIANT" != "dark" ]]; then
    FORCE_INKSCAPE="$OPTION_FORCE_INKSCAPE" GTK2_HIDPI="$OPTION_GTK2_HIDPI" ./render-assets.sh gtk2-light
else
    FORCE_INKSCAPE="$OPTION_FORCE_INKSCAPE" GTK2_HIDPI="$OPTION_GTK2_HIDPI" ./render-assets.sh gtk2-dark
fi

echo "== Rendering GTK 3 assets..."
FORCE_INKSCAPE="$OPTION_FORCE_INKSCAPE" ./render-assets.sh gtk

meson _build -Dprefix="$tempdir" -Dcolors="$COLOR_VARIANT" -Dsizes="$SIZE_VARIANT"
meson install -C _build
GENERATED_PATH="$tempdir/share/themes/Materia$COLOR_SUFFIX$SIZE_SUFFIX"
if [[ -d "$DEST_PATH" ]]; then
    rm -r "$DEST_PATH"
elif [[ ! -d "$(dirname "$DEST_PATH")" ]]; then
    mkdir -p "$(readlink -f "$(dirname "$DEST_PATH")")"
fi
mv "$GENERATED_PATH" "$DEST_PATH"


echo
echo "== SUCCESS"
echo "== The theme was installed to '$DEST_PATH'"
exit 0
