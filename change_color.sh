#!/usr/bin/env bash
#set -x
set -ue
SRC_PATH=$(readlink -f $(dirname $0))

darker () {
	"${SRC_PATH}/scripts/darker.sh" $@
}
mix () {
	"${SRC_PATH}/scripts/mix.sh" $@
}


print_usage() {
	echo "usage: $0 [-o OUTPUT_THEME_NAME] [-p PATH_LIST] PATH_TO_PRESET"
	echo "examples:"
	echo "       $0 -o my-theme-name <(echo -e "BG=d8d8d8\\nFG=101010\\nMENU_BG=3c3c3c\\nMENU_FG=e6e6e6\\nSEL_BG=ad7fa8\\nSEL_FG=ffffff\\nTXT_BG=ffffff\\nTXT_FG=1a1a1a\\nBTN_BG=f5f5f5\\nBTN_FG=111111\\n")"
	echo "       $0 ../colors/retro/twg"
	echo "       $0 --hidpi True ../colors/retro/clearlooks"
	exit 1
}


while [[ $# > 0 ]]
do
	case ${1} in
		-p|--path-list)
			CUSTOM_PATHLIST="${2}"
			shift
		;;
		-o|--output)
			OUTPUT_THEME_NAME="${2}"
			shift
		;;
		-d|--hidpi)
			OPTION_GTK2_HIDPI="${2}"
			shift
		;;
		*)
			if [[ "${1}" == -* ]] || [[ ${THEME-} ]]; then
				echo "unknown option ${1}"
				print_usage
				exit 2
			fi
			THEME="${1}"
		;;
	esac
	shift
done

if [[ -z "${THEME:-}" ]] ; then
	print_usage
fi

PATHLIST=(
	'./src/chrome'
	'./src/gnome-shell'
	'./src/gtk-2.0/gtkrc'
	'./src/gtk-2.0/gtkrc-dark'
	'./src/gtk-2.0/gtkrc-light'
	'./src/gtk-3.0/3.22/sass/_colors.scss'
	'./src/gtk-2.0/assets.svg'
	'./src/gtk-2.0/assets-dark.svg'
	'./src/gtk-3.0/gtk-common/assets.svg'
	'./src/metacity-1'
	'./src/unity'
	'./src/xfwm4'
)
GNOME_SHELL_PATHLIST=(
	'./src/gnome-shell/3.18/sass/_colors.scss'
	'./src/gnome-shell/3.20/sass/_colors.scss'
	'./src/gnome-shell/3.22/sass/_colors.scss'
)
PATHLIST=("${PATHLIST[@]}" "${GNOME_SHELL_PATHLIST[@]}")
if [ ! -z "${CUSTOM_PATHLIST:-}" ] ; then
	IFS=', ' read -r -a PATHLIST <<< "${CUSTOM_PATHLIST:-}"
fi

EXPORT_QT5CT=0
for FILEPATH in "${PATHLIST[@]}"; do
	if [[ ${FILEPATH} == *qt5ct* ]] ;then
		EXPORT_QT5CT=1
	fi
done

OPTION_GTK2_HIDPI=$(echo ${OPTION_GTK2_HIDPI-False} | tr '[:upper:]' '[:lower:]')


if [[ ${THEME} == */* ]] || [[ ${THEME} == *.* ]] ; then
	source "$THEME"
	THEME=$(basename ${THEME})
else
	if [[ -f "$SRC_PATH/../colors/$THEME" ]] ; then
		source "$SRC_PATH/../colors/$THEME"
	else
		echo "Theme '${THEME}' not found"
		exit 1
	fi
fi
ACCENT_BG=${ACCENT_BG-$SEL_BG}
HDR_BTN_BG=${HDR_BTN_BG-$BTN_BG}
HDR_BTN_FG=${HDR_BTN_FG-$BTN_FG}
WM_BORDER_FOCUS=${WM_BORDER_FOCUS-$SEL_BG}
WM_BORDER_UNFOCUS=${WM_BORDER_UNFOCUS-$MENU_BG}

MATERIA_STYLE_COMPACT=$(echo ${MATERIA_STYLE_COMPACT-True} | tr '[:upper:]' '[:lower:]')
MATERIA_MENUBAR_STYLE=$(echo ${MATERIA_MENUBAR_STYLE-same} | tr '[:upper:]' '[:lower:]')
GTK3_GENERATE_DARK=$(echo ${GTK3_GENERATE_DARK-True} | tr '[:upper:]' '[:lower:]')
UNITY_DEFAULT_LAUNCHER_STYLE=$(echo ${UNITY_DEFAULT_LAUNCHER_STYLE-False} | tr '[:upper:]' '[:lower:]')

SPACING=${SPACING-3}
GRADIENT=${GRADIENT-0}
ROUNDNESS=${ROUNDNESS-2}
ROUNDNESS_GTK2_HIDPI=$(( ${ROUNDNESS} * 2 ))
GNOME_SHELL_PANEL_OPACITY=${GNOME_SHELL_PANEL_OPACITY-0.6}

INACTIVE_FG=$(mix ${FG} ${BG} 0.75)
INACTIVE_MENU_FG=$(mix ${MENU_FG} ${MENU_BG} 0.75)
INACTIVE_MENU_BG=$(mix ${MENU_BG} ${MENU_FG} 0.75)
INACTIVE_TXT_FG=$(mix ${TXT_FG} ${TXT_BG} 0.75)
INACTIVE_TXT_BG=$(mix ${TXT_BG} ${BG} 0.60)

light_folder_base_fallback="$(darker ${SEL_BG} -10)"
medium_base_fallback="$(darker ${SEL_BG} 37)"
dark_stroke_fallback="$(darker ${SEL_BG} 50)"

OUTPUT_THEME_NAME="${OUTPUT_THEME_NAME-oomox-$THEME}"
DEST_PATH="$HOME/.themes/${OUTPUT_THEME_NAME/\//-}"

test "$SRC_PATH" = "$DEST_PATH" && echo "can't do that" && exit 1


tempdir=$(mktemp -d)
function post_clean_up {
	rm -r "${tempdir}" || true
}
trap post_clean_up EXIT SIGHUP SIGINT SIGTERM
cp -r ${SRC_PATH}/* ${tempdir}/
cd ${tempdir}


echo "== Converting theme into template..."

for FILEPATH in "${GNOME_SHELL_PATHLIST[@]}"; do
	sed -i'' \
		-e 's/^\($bg_color:.*,\) $middle_opacity/\1 %GNOME_SHELL_PANEL_OPACITY%/g' \
		-e 's/^\(\$dark_fg_color:.*rgba(\)$.*\(,.*;\).*$/\1 %MENU_FG% \2/g' \
		-e 's/^\(\$light_fg_color:\).*$.*;.*$/\1 %MENU_FG%;/g' \
		-e 's/^\(\$base_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%MENU_BG%\2%MENU_BG%\3/g' \
		-e 's/^\(\$alt_base_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%INACTIVE_MENU_BG%\2%INACTIVE_MENU_BG%\3/g' \
		-e 's/$black/%MENU_BG%/g' \
		-e 's/$grey_900/%MENU_BG%/g' \
		-e 's/$white/%MENU_FG%/g' \
		${FILEPATH}
done

for FILEPATH in "${PATHLIST[@]}"; do
	find "${FILEPATH}" -type f -not -name '_color-palette.scss' -exec sed -i'' \
		-e 's/^\(\$dark_fg_color:\).*$.*;.*$/\1 %FG%;/g' \
		-e 's/^\(\$light_fg_color:\).*$.*;.*$/\1 %BG%;/g' \
		\
		-e 's/^\(\$fg_color:\).*;.*$/\1 %FG%;/g' \
		-e 's/^\(\$button_fg_color:\).*;.*$/\1 %BTN_FG%;/g' \
		-e 's/^\(\$secondary_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%BTN_FG%\2%BTN_FG%\3/g' \
		-e 's/^\(\$hint_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%FG%\2%FG%\3/g' \
		-e 's/^\(\$disabled_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%FG%\2%FG%\3/g' \
		-e 's/^\(\$disabled_secondary_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%BTN_FG%\2%BTN_FG%\3/g' \
		-e 's/^\(\$track_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%FG%\2%FG%\3/g' \
		-e 's/^\(\$divider_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%FG%\2%FG%\3/g' \
		\
		-e 's/^\(\$titlebar_fg_color:\).*;.*$/\1 %MENU_FG%;/g' \
		-e 's/^\(\$titlebar_secondary_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		-e 's/^\(\$titlebar_hint_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		-e 's/^\(\$titlebar_disabled_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		-e 's/^\(\$titlebar_disabled_secondary_fg_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		-e 's/^\(\$titlebar_track_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		-e 's/^\(\$titlebar_divider_color:.*\)\$black\(.*\)\$white\(.*\)$/\1%MENU_FG%\2%MENU_FG%\3/g' \
		\
		-e 's/^\(\$inverse_fg_color:\).*;.*$/\1 %SEL_FG%;/g' \
		-e 's/^\(\$inverse_secondary_fg_color:.*\)$white\(.*\)$/\1%SEL_FG%\2/g' \
		-e 's/^\(\$inverse_hint_fg_color:.*\)\$white\(.*\)$/\1%SEL_FG%\2/g' \
		-e 's/^\(\$inverse_disabled_fg_color:.*\)\$white\(.*\)$/\1%SEL_FG%\2/g' \
		-e 's/^\(\$inverse_disabled_secondary_fg_color:.*\)\$white\(.*\)$/\1%SEL_FG%\2/g' \
		-e 's/^\(\$inverse_track_color:.*\)\$white\(.*\)$/\1%SEL_FG%\2/g' \
		-e 's/^\(\$inverse_divider_color:.*\)\$white\(.*\)$/\1%SEL_FG%\2/g' \
		\
		-e 's/^\(\$bg_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%BG%\2%MENU_BG%\3/g' \
		-e 's/^\(\$base_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%TXT_BG%\2%MENU_BG%\3/g' \
		-e 's/^\(\$alt_base_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%INACTIVE_TXT_BG%\2%INACTIVE_TXT_BG%\3%MENU_BG%\4/g' \
		-e 's/^\(\$lighter_bg_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%BTN_BG%\2%BTN_BG%\3/g' \
		-e 's/^\(\$darker_bg_color:.*\$variant.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%BG%\2%MENU_BG%\3/g' \
		\
		-e 's/^\(\$titlebar_bg_color:\).*;.*$/\1 %MENU_BG%;/g' \
		-e 's/^\(\$alt_titlebar_bg_color:.*\$titlebar.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%MENU_BG%\2%MENU_BG%\3/g' \
		-e 's/^\(\$panel_bg_color:.*\)$black\(.*\)$/\1%MENU_BG%\2/g' \
		-e 's/^\(\$solid_panel_bg_color:.*\$titlebar.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%MENU_BG%\2%MENU_BG%\3/g' \
		-e 's/^\(\$opaque_panel_bg_color:.*\$titlebar.*\)\$\w\+\(.*\)\$\w\+\(.*\)\$\w\+\(.*\)$/\1%MENU_BG%\2%MENU_BG%\3%MENU_BG%\4/g' \
		-e 's/^\(\$alt_panel_bg_color:.*\)$black\(.*\)$/\1%MENU_BG%\2/g' \
		\
		-e 's/^\(\$primary_color:\).*;.*$/\1 %SEL_BG%;/g' \
		-e 's/^\(\$alt_primary_color:\).*;.*$/\1 %SEL_BG2%;/g' \
		-e 's/^\(\$accent_color:\).*;.*$/\1 %ACCENT_BG%;/g' \
		\
		-e 's/^\(\$titlebar_highlight_color:\).*;.*$/\1 %MENU_BG%;/g' \
		\
		-e 's/$black/%FG%/g' \
		-e 's/#000000/%FG%/g' \
		-e 's/$grey_900/%FG%/g' \
		-e 's/#212121/%FG%/g' \
		-e 's/$grey_500/%INACTIVE_FG%/g' \
		-e 's/#757575/%INACTIVE_FG%/g' \
		-e 's/#9E9E9E/%INACTIVE_FG%/g' \
		-e 's/#c3c8ca/%INACTIVE_FG%/g' \
		-e 's/$grey_400/%MENU_BG2%/g' \
		-e 's/#BDBDBD/%MENU_BG2%/g' \
		-e 's/$grey_300/%SEL_BG%/g' \
		-e 's/#E0E0E0/%SEL_BG%/g' \
		-e 's/$grey_200/%BG2%/g' \
		-e 's/$grey_100/%BG%/g' \
		-e 's/#F5F5F5/%BG%/g' \
		-e 's/$grey_50/%BTN_BG%/g' \
		-e 's/#FAFAFA/%BTN_BG%/g' \
		-e 's/$pink_A200/%ACCENT_BG%/g' \
		-e 's/#FF4081/%ACCENT_BG%/g' \
		-e 's/$blue_400/%SEL_BG%/g' \
		-e 's/#42A5F5/%SEL_BG%/g' \
		-e 's/$light_blue_A200/%SEL_BG2%/g' \
		-e 's/$white/%TXT_BG%/g' \
		-e 's/#FFFFFF/%TXT_BG%/g' \
		-e 's/$blue_grey_700/%MENU_BG%/g' \
		-e 's/$blue_grey_600/%MENU_BG%/g' \
		-e 's/#333e43/%MENU_BG%/g' \
		-e 's/#455A64/%MENU_BG%/g' \
		-e 's/#37474F/%MENU_BG%/g' \
		-e 's/$blue_grey_800/%MENU_BG2%/g' \
		-e 's/#3b484e/%MENU_BG2%/g' \
		-e 's/$blue_grey_900/%MENU_BG3%/g' \
		-e 's/#414f56/%MENU_BG3%/g' \
		-e 's/Materia/%OUTPUT_THEME_NAME%/g' \
		{} \; ;
done

#Not implemented yet:
		#-e 's/%HDR_BTN_BG%/'"$HDR_BTN_BG"'/g' \
		#-e 's/%HDR_BTN_FG%/'"$HDR_BTN_FG"'/g' \
		#-e 's/%WM_BORDER_FOCUS%/'"$WM_BORDER_FOCUS"'/g' \
		#-e 's/%WM_BORDER_UNFOCUS%/'"$WM_BORDER_UNFOCUS"'/g' \
		#-e 's/%ROUNDNESS%/'"$ROUNDNESS"'/g' \
		#-e 's/%SPACING%/'"$SPACING"'/g' \
		#-e 's/%INACTIVE_FG%/'"$INACTIVE_FG"'/g' \
		#-e 's/%INACTIVE_TXT_FG%/'"$INACTIVE_TXT_FG"'/g' \
		#-e 's/%INACTIVE_MENU_FG%/'"$INACTIVE_MENU_FG"'/g' \

if [[ ! -z "${DEBUG:-}" ]] ; then
	echo "You can debug TEMP DIR: ${tempdir}, press [Enter] when finish" && read
fi

echo "== Filling the template with the new colorscheme..."
for FILEPATH in "${PATHLIST[@]}"; do
	find "${FILEPATH}" -type f -exec sed -i'' \
		-e 's/%BG%/#'"$BG"'/g' \
		-e 's/%BG2%/#'"$(darker $BG)"'/g' \
		-e 's/%FG%/#'"$FG"'/g' \
		-e 's/%ACCENT_BG%/#'"$ACCENT_BG"'/g' \
		-e 's/%SEL_BG%/#'"$SEL_BG"'/g' \
		-e 's/%SEL_BG2%/#'"$(darker $SEL_BG -20)"'/g' \
		-e 's/%SEL_FG%/#'"$SEL_FG"'/g' \
		-e 's/%TXT_BG%/#'"$TXT_BG"'/g' \
		-e 's/%TXT_FG%/#'"$TXT_FG"'/g' \
		-e 's/%MENU_BG%/#'"$MENU_BG"'/g' \
		-e 's/%MENU_BG2%/#'"$(darker $MENU_BG 10)"'/g' \
		-e 's/%MENU_BG3%/#'"$(darker $MENU_BG 20)"'/g' \
		-e 's/%MENU_FG%/#'"$MENU_FG"'/g' \
		-e 's/%BTN_BG%/#'"$BTN_BG"'/g' \
		-e 's/%BTN_FG%/#'"$BTN_FG"'/g' \
		-e 's/%HDR_BTN_BG%/#'"$HDR_BTN_BG"'/g' \
		-e 's/%HDR_BTN_FG%/#'"$HDR_BTN_FG"'/g' \
		-e 's/%WM_BORDER_FOCUS%/#'"$WM_BORDER_FOCUS"'/g' \
		-e 's/%WM_BORDER_UNFOCUS%/#'"$WM_BORDER_UNFOCUS"'/g' \
		-e 's/%ROUNDNESS%/'"$ROUNDNESS"'/g' \
		-e 's/%SPACING%/'"$SPACING"'/g' \
		-e 's/%INACTIVE_FG%/#'"$INACTIVE_FG"'/g' \
		-e 's/%INACTIVE_TXT_FG%/#'"$INACTIVE_TXT_FG"'/g' \
		-e 's/%INACTIVE_TXT_BG%/#'"$INACTIVE_TXT_BG"'/g' \
		-e 's/%INACTIVE_MENU_FG%/#'"$INACTIVE_MENU_FG"'/g' \
		-e 's/%INACTIVE_MENU_BG%/#'"$INACTIVE_MENU_BG"'/g' \
		-e 's/%GNOME_SHELL_PANEL_OPACITY%/'"$GNOME_SHELL_PANEL_OPACITY"'/g' \
		-e 's/%OUTPUT_THEME_NAME%/'"$OUTPUT_THEME_NAME"'/g' \
		{} \; ;
done

rm ./src/gtk-3.0/3.{18,20,22}/*.css
if [[ ${MATERIA_MENUBAR_STYLE}  == "contrast" ]] ; then
	rm ./src/gtk-3.0/3.{18,20,22}/gtk-light*.scss
else
	rm ./src/gtk-3.0/3.{18,20,22}/gtk{,-compact}.scss || true
fi
if [[ ${GTK3_GENERATE_DARK} != "true" ]] ; then
	grep -v "\-dark" ./src/gtk-3.0/gtk-common/assets.txt > ./new_assets.txt
	mv ./new_assets.txt ./src/gtk-3.0/gtk-common/assets.txt
	rm ./src/gtk-3.0/3.{20,22}/gtk-dark-compact.scss
	rm ./src/gtk-3.0/3.{18,20,22}/gtk-dark.scss
fi
if [[ ${OPTION_GTK2_HIDPI} == "true" ]] ; then
	mv ./src/gtk-2.0/main.rc.hidpi ./src/gtk-2.0/main.rc
fi
if [[ ${EXPORT_QT5CT} = 1 ]] ; then
	config_home=${XDG_CONFIG_HOME:-}
	if [[ -z "${config_home}" ]] ; then
		config_home="${HOME}/.config"
	fi
	qt5ct_colors_dir="${config_home}/qt5ct/colors/"
	test -d ${qt5ct_colors_dir} || mkdir -p ${qt5ct_colors_dir}
	mv ./src/qt5ct_palette.conf "${qt5ct_colors_dir}/${OUTPUT_THEME_NAME}.conf"
fi
if [[ ${UNITY_DEFAULT_LAUNCHER_STYLE} == "true" ]] ; then
	rm ./src/unity/launcher*.svg
fi

if [[ ${MATERIA_STYLE_COMPACT}  == "true" ]] ; then
	SIZE_VARIANTS="-compact"
else
	SIZE_VARIANTS=","
fi
if [[ ${MATERIA_MENUBAR_STYLE}  == "contrast" ]] ; then
	COLOR_VARIANTS=","
else
	COLOR_VARIANTS="-light"
fi

SIZE_VARIANTS="${SIZE_VARIANTS}" COLOR_VARIANTS="${COLOR_VARIANTS}" THEME_DIR_BASE=${DEST_PATH} ./parse-sass.sh

rm ./src/gtk-2.0/assets/*.png || true
rm ./src/gtk-2.0/assets-dark/*.png || true
rm ./src/gtk-3.0/gtk-common/assets/*.png || true

echo "== Rendering GTK+2 assets..."
cd ./src/gtk-2.0
GTK2_HIDPI=${OPTION_GTK2_HIDPI} ./render-assets.sh
cd ../../

echo "== Rendering GTK+3 assets..."
cd ./src/gtk-3.0/gtk-common
./render-assets.sh
cd ../../..

SIZE_VARIANTS="${SIZE_VARIANTS}" COLOR_VARIANTS="${COLOR_VARIANTS}" THEME_DIR_BASE=${DEST_PATH} ./install.sh

GENERATED_PATH="${DEST_PATH}$(tr -d ',' <<<${COLOR_VARIANTS})$(tr -d ',' <<<${SIZE_VARIANTS})"
if [[ ! "${GENERATED_PATH}" = "${DEST_PATH}" ]] ; then
	if [[ -d "${DEST_PATH}" ]] ; then
		rm -r "${DEST_PATH}"
	fi
	mv "${GENERATED_PATH}" "${DEST_PATH}"
fi

echo
echo "== SUCCESS"
echo "== The theme was installed to '${DEST_PATH}'"
exit 0
