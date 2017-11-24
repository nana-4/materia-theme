#!/bin/env bash
set -e
if [ $# -eq 0 ]; then
    echo "$0: missing argument"
    echo "Try '$0 --help' for more information."
    exit 1
fi
REPO_DIR=$(cd $(dirname $0) && 'pwd')
SRC_DIR=${REPO_DIR}/src
THEME_DIR=$HOME/.themes
# List of supported gtk versions
gtk_ver=('3.18' '3.20' '3.22')
# List of supported gnome-shell versions
gs_ver=('3.18' '3.20' '3.22' '3.24' '3.26')
# Materia theme variants
color_variants=('' '-dark' '-light')
size_variants=('' '-compact')
################################################
usage() {
    printf "%s\n" "Usage: $0 install [OPTIONS...] [DST-DIR]"
    printf "%s\n" "   or: $0 assets [ASSETS OPTIONS...]" 
    printf "%s\n" "   or: $0 render-assets"
    printf "\n%s\n" "MANDATORY ARGUMENTS:"
    printf "  %-20s%s\n" "install" "Installing theme"
    printf "  %-20s%s\n" "assets" "Changing assets color"
    printf "  %-20s%s\n" "render-assets" "Rendering assets color" 
    printf "\n%s\n" "OPTIONS:"
    printf "  %-20s%s\n" "-c, --color" "Specify theme color variant (Default to ALL variants)"
    printf "  %-20s%s\n" "-s, --size" "Specify theme size variant (Default to ALL sizes)"
    printf "  %-20s%s\n" "-n, --name" "Specify theme name (Default to Materia-color-size)"
    printf "  %-20s%s\n" "-d, --dst" "Specify theme destination folder (Default to ~/.themes)"
    printf "  %-20s%s\n" "-h, --help" "Show this help"
    #printf "  %-20s%s\n" "asset" "Change assets color(Only takes ASSETS OPTIONS as an arg)"
    #printf "  %-20s%s\n" "render-assets" "Rendering assets (Default to ouput PNGs with 90&192 dpi)" 
    printf "\n%s\n" "ASSETS OPTIONS:"
    printf "  %-25s%s\n" "--fg" "Change assets color-fg"
    printf "  %-25s%s\n" "--fg-dark" "Change assets color-fg-dark"
    printf "  %-25s%s\n" "--bg" "Change assets color-bg"
    printf "  %-25s%s\n" "--bg-dark" "Change assets color-bg-dark"
    printf "  %-25s%s\n" "--bg-lighter" "Change assets color-bg-lighter"
    printf "  %-25s%s\n" "--bg-lighter-dark" "Change assets color-bg-lighter-dark"
    printf "  %-25s%s\n" "--base" "Change assets color-base"
    printf "  %-25s%s\n" "--base-dark" "Change assets color-base-dark"
    printf "  %-25s%s\n" "--accent" "Change assets color-accent"
    printf "\n" 
    printf "%s\n" "INSTALLATION EXAMPLES:"
    printf "%s\n" "Install all theme variants with default name"
    printf "\t%s\t%s\n" "./materia install" 
    printf "%s\n" "Install all theme variants with different name"
    printf "\t%s\t%s\n" "./materia install -n mytheme"
    printf "%s\n" "Install one theme varinat"
    printf "\t%s\t%s\n" "./materia install --color dark"
    printf "\t%s\t%s\n" "./materia install --color light"
    printf "%s\n" "Install all compact variants"
    printf "\t%s\t%s\n" "./materia install --size compact"
    printf "%s\n" "Install only one specifc theme varinat"
    printf "\t%s\t%s\n" "./materia install --color light --size compact"
    printf "\t%s\t%s\n" "./materia install --color light --size compact -n mytheme"
    printf "\n%s\n" "ASSETS EXAMPLES:"
    printf "%s\n" "Follow these steps to change assets color"
    printf "  %s\n" "1- Change assets color"
    printf "\t%s%s\n" "./materia --accent "#0000FF" --bg "#212121" ...."
    printf "  %s\n" "2- Render assets color"
    printf "\t%s%s\n" "./materia render-assets"
    printf "  %s\n" "3- Replace the new assets folder with your theme assets folder"
    printf "%s\n" "NOTE:'$0 assets' will create a backup of your assets.svg and assets folder."
    printf "%s\n" "So you can get back to theme incase you messed up the colors."

}
#usage
#exit 1
# Progress bar 
progress () {
    s=0.5;
    f=0.25;
    echo -ne "\r"
    while true; do
       sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[           ] [0%]."  \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[#          ] [10%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[##         ] [20%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[####       ] [30%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[#####      ] [40%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[######     ] [50%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[#######    ] [60%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[########   ] [70%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[#########  ] [80%]." \
    && sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[########## ] [90%]." ; 
       sleep $f && s=`echo ${s} + ${f} + ${f} | bc` && echo -ne "\r\t\t\t\t\t[###########] [100%].";
    done
    echo -ne "\n"
}
# Get gnome-shell version
if [[ $(which gnome-shell 2> /dev/null) ]]; then
    gnome_shell_ver=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 1,2)
    if [[ ! "${gs_ver[@]}" =~ "${gnome_shell_ver}" ]]; then
        gnome_shell_ver=3.18
    fi
else
    gnome_shell_ver=3.18
fi
remove_materia () {
    #echo "Start removing Materia theme ..."
    if [ -d "${1}" ]; then
        rm -rf ${1}
    fi
    #find $HOME/.themes -iname "Materia*" -type d -exec rm -rf "{}" \+
    #echo "Materia theme successfully removed."
}
# Install index.theme 
install_index_theme () {
    cp -ur ${SRC_DIR}/index.theme "${2}"
    sed -i "s/Materia\$/"${1}"/g" "${2}"/index.theme
    #echo "index.theme succussfully installed"
}
# Install gnome-shell theme 
install_gnome_shell () {
    gs_src_dir=${SRC_DIR}/gnome-shell/${gnome_shell_ver}
    gs_dst_dir="${3}/gnome-shell"
    install -d "${gs_dst_dir}"
    cp -ur ${gs_src_dir}/*.svg ${gs_dst_dir}
    cp -urL ${gs_src_dir}/{extensions,pad-osd.css} ${gs_dst_dir}
    if [ "${1}" != "-dark" ]; then
        cp -urL ${gs_src_dir}/assets ${gs_dst_dir}
    else
        cp -urL ${gs_src_dir}/assets-dark ${gs_dst_dir}/assets
    fi
    # Compile .scss files to .css files 
    sass "${gs_src_dir}/gnome-shell${1}${2}.scss" "${gs_dst_dir}/gnome-shell.css"
    # Create a binary resource bundle from .gresource.xml
    glib-compile-resources --sourcedir=${gs_dst_dir} \
        --target=${gs_dst_dir}/gnome-shell-theme.gresource \
        ${gs_src_dir}/gnome-shell-theme.gresource.xml
    #echo "Finished installing gnome-shell."
}
# Installing GTK+ 2 Theme
install_gtk2_theme () {
    install -d "${3}/gtk-2.0"
    cp -ur ${SRC_DIR}/gtk-2.0/{apps,hacks,main}.rc ${3}/gtk-2.0
    cp -ur ${SRC_DIR}/gtk-2.0/gtkrc${1} ${3}/gtk-2.0/gtkrc
    if [ "${1}" == "-dark" ]; then
        cp -ur ${SRC_DIR}/gtk-2.0/assets${1} ${3}/gtk-2.0/assets
    else
        cp -ur ${SRC_DIR}/gtk-2.0/assets ${3}/gtk-2.0
    fi
    #echo "Finished installing GTK+ 2 theme."
}
# Installing GTK+ 3 Theme 
install_gtk3_theme () {
    install -d "${3}/gtk-common"
    cp -ur ${SRC_DIR}/gtk-3.0/gtk-common/assets ${3}/gtk-common
    for ver in "${gtk_ver[@]}"; do 
        if [ "${ver}"  == "3.18" ]; then
            install -d "${3}/gtk-3.0"
            cp -ur ${SRC_DIR}/gtk-3.0/${ver}/assets ${3}/gtk-3.0
            sass "${SRC_DIR}/gtk-3.0/${ver}/gtk${1}.scss" "${3}/gtk-3.0/gtk.css" &>/dev/null
        else
            install -d "${3}/gtk-${ver}"
            cp -ur ${SRC_DIR}/gtk-3.0/${ver}/assets ${3}/gtk-${ver}
            sass "${SRC_DIR}/gtk-3.0/${ver}/gtk${1}${2}.scss" "${3}/gtk-${ver}/gtk.css" &>/dev/null
        fi
    done
    #echo "Finished installing GTK+ 3 theme."
}
# Installing Metacity Theme
install_metacity_theme () {
    install -d "${3}/metacity-1"
    cp -ur ${SRC_DIR}/metacity-1/assets ${3}/metacity-1 
    if [ "${1}" != "-light" ]; then
        cp -ur ${SRC_DIR}/metacity-1/metacity-theme-{2,3}.xml ${3}/metacity-1 
    else
        cp -ur ${SRC_DIR}/metacity-1/metacity-theme-2${1}.xml ${3}/metacity-1/metacity-theme-2.xml 
        cp -ur ${SRC_DIR}/metacity-1/metacity-theme-3${1}.xml ${3}/metacity-1/metacity-theme-3.xml 
    fi
    #echo "Finished installing Metacity theme."
}
# Installing Unity Theme
install_unity_theme () {
    install -d "${3}/unity"
    cp -ur ${SRC_DIR}/unity/*.{svg,png,json} ${3}/unity
    if [ "${1}" != "-light" ]; then
        cp -ur ${SRC_DIR}/unity/assets ${3}/unity 
    else
        cp -urT ${SRC_DIR}/unity/assets${1} ${3}/unity/assets 
    fi
    #echo "Finished installing Unity theme."
}
# Installing Xfwm Theme
install_xfwm_theme () {
    install -d ${3}/xfwm4
    cp -ur ${SRC_DIR}/xfwm4/{*.svg,themerc} ${3}/xfwm4
    if [ "${1}" != "-light" ]; then
        cp -ur ${SRC_DIR}/xfwm4/assets ${3}/xfwm4 
    else
        cp -urT ${SRC_DIR}/xfwm4/assets${1} ${3}/xfwm4/assets 
    fi
    #echo "Finished installing Xfwm4 theme."

}
# Rename the theme 
set_theme_name () {
    if [[ "${iFlags[2]}" = "false" ]]; then
        theme_name=Materia$1$2
    elif [[ "${iFlags[0]}" == "true" && "${iFlags[1]}" == "true" && "${iFlags[2]}" == "true" ]]; then
        theme_name="${new_theme_name}"
    else
        theme_name="${new_theme_name}"$1$2
    fi
}
# Install specific theme variant(s) default to ALL
set_theme_variant () {
    if [ "${iFlags[0]}" == "false" -a "${iFlags[1]}" == "false" ]; then
        theme_color=("${color_variants[@]}")
        theme_size=("${size_variants[@]}")
    elif [ "${iFlags[0]}" == "true" -a "${iFlags[1]}" == "false" ]; then
        theme_color="$1"
        theme_size=("${size_variants[@]}")
    elif [ "${iFlags[0]}" == "false" -a "${iFlags[1]}" == "true" ]; then
        theme_color=("${color_variants[@]}")
        theme_size="$2"
    else
        theme_color="$1"
        theme_size="$2"
    fi
}
# Validate theme variant  
is_valid_variant () {
    if [[ ! " ${color_variants[@]} " =~ " $1 " ]]; then
        echo "ERROR: Unsupported color variant '"${1:1}"'."
        echo "Try '$0 --help' for more inforamtion."
        exit 1
    fi
}
# Validate theme size 
is_valid_size () {
    if [[ ! " ${size_variants[@]} " =~ " $1 " ]]; then
        echo "ERROR: Unsupported size variant '"${1:1}"'."
        echo "Try '$0 --help' for more inforamtion."
        exit 1
    fi
}
# Validate color
re_hexcolor='^#[0-9a-fA-F]{6}$'
is_valid_color () {
    if [[ -z "${2}" ]]; then
        echo "ERROR: '${1} \"${2}\"', color cannot be empty."
        exit 1
    elif [[ ! "${2}" =~ $re_hexcolor ]]; then
        echo "ERROR: '${1} \"${2}\"', color must be in hex format e.g. "#ffffff". "
        exit 1
    fi
}
# By default Materia will install all color variants and sizes
# Main function
install_materia () {
    for color in "${theme_color[@]}"; do 
        for size in "${theme_size[@]}"; do
            set_theme_name ${color} ${size}
            theme_dir=${1:-${THEME_DIR}}/${theme_name}
            remove_materia "${theme_name}"
            install -d "${theme_dir}"
            cp -ur ${REPO_DIR}/COPYING ${theme_dir}
            printf "\n%s" "Installing $theme_name: " 
            #while true; do progress;done &
            install_index_theme "${theme_name}" "${theme_dir}"
            install_gnome_shell "${color}" "${size}" "${theme_dir}" "${theme_name}"
            install_gtk3_theme "${color}" "${size}" "${theme_dir}"
            install_gtk2_theme "${color}" "${size}" "${theme_dir}"
            install_metacity_theme "${color}" "${size}" "${theme_dir}"
            install_unity_theme "${color}" "${size}" "${theme_dir}"
            install_xfwm_theme "${color}" "${size}" "${theme_dir}"
            #kill $!;trap 'kill $!' SIGTERM SIGKILL
       done
   done
}
# Change assets.svg colors 
change_asset_color () {
    sed -i "/\"${1}\"/{n;s/\(.*stop-color=\"\).[^\"]*/\1${2}/g}" ${SRC_DIR}/gtk-3.0/gtk-common/assets.svg 
}

# Get old asset color 
get_old_asset_color () {
    old_color="$(sed -n "/<linearGradient.id=\"${1}\">/{n;s/.*<stop.stop-color=\"\(#.[^\"]*\).[^>]*>/\1/p}" ${SRC_DIR}/gtk-3.0/gtk-common/assets.svg)"
}
# Get old assets color
old_assets_color () {
    get_old_asset_color "color-fg"
    old_color_fg="${old_color}"
    get_old_asset_color "color-fg-dark"
    old_color_fg_dark="${old_color}"
    get_old_asset_color "color-fg-secondary"
    old_color_fg_secondary="$old_color"
    get_old_asset_color "color-fg-secondary-dark"
    old_color_fg_secondary_dark="$old_color"
    get_old_asset_color "color-fg-secondary-disabled"
    old_color_fg_secondary_disabled="$old_color"
    get_old_asset_color "color-fg-secondary-disabled-dark"
    old_color_fg_secondary_disabled_dark="$old_color"
    get_old_asset_color "color-bg"
    old_color_bg="$old_color"
    get_old_asset_color "color-bg-dark"
    old_color_bg_dark="$old_color"
    get_old_asset_color "color-bg-lighter"
    old_color_bg_lighter="$old_color"
    get_old_asset_color "color-bg-lighter-dark"
    old_color_bg_lighter_dark="$old_color"
    get_old_asset_color "color-base"
    old_color_base="$old_color"
    get_old_asset_color "color-base-dark"
    old_color_base_dark="$old_color"
    get_old_asset_color "color-divider"
    old_color_divider="$old_color"
    get_old_asset_color "color-divider-dark"
    old_color_divider_dark="$old_color"
    get_old_asset_color "color-accent"
    old_color_accent="$old_color"
    get_old_asset_color "color-accent-disabled"
    old_color_accent_disabled="$old_color"
}
# Change assets color 
change_assets_color () {
    gtk_common_dir="${SRC_DIR}/gtk-3.0/gtk-common"
    if [ ! -f "${gtk_common_dir}/assets_original.svg" ]; then
        cp ${gtk_common_dir}/assets.svg ${gtk_common_dir}/assets_original.svg
    fi
    old_assets_color
    if [ "${aFlags[0]}" == "true" -a "${old_color_fg}" != "color_fg" ]; then
        change_asset_color "color-fg" "${color_fg}"
        change_asset_color "color-fg-secondary" "${color_fg}"
        change_asset_color "color-fg-secondary-disabled" "${color_fg}"
        change_asset_color "color-divider" "${color_fg}"
    fi
    if [ "${aFlags[1]}" == "true" -a "${old_color_fg_dark}" != "color_fg_dark" ]; then
        change_asset_color "color-fg-dark" "${color_fg_dark}"
        change_asset_color "color-fg-secondary-dark" "${color_fg_dark}"
        change_asset_color "color-fg-secondary-disabled-dark" "${color_fg_dark}"
        change_asset_color "color-divider-dark" "${color_divider_dark}"
    fi
    if [ "${aFlags[2]}" == "true" -a "${old_color_bg}" != "color_bg" ]; then
        change_asset_color "color-bg" "${color_bg}"
    fi
    if [ "${aFlags[3]}" == "true" -a "${old_color_bg_dark}" != "color_bg_dark" ]; then
        change_asset_color "color-bg-dark" "${color_bg_dark}"
    fi
    if [ "${aFlags[4]}" == "true" -a "${old_color_bg_lighter}" != "color_bg_lighter" ]; then
        change_asset_color "color-bg-lighter" "${color_bg_lighter}"
    fi
    if [ "${aFlags[5]}" == "true" -a "${old_color_bg_lighter_dark}" != "color_bg_lighter_dark" ]; then
        change_asset_color "color-bg-lighter-dark" "${color_bg_lighter_dark}"
    fi
    if [ "${aFlags[6]}" == "true" -a "${old_color_base}" != "color_base" ]; then
        change_asset_color "color-base" "${color_base}"
    fi
    if [ "${aFlags[7]}" == "true" -a "${old_color_base_dark}" != "color_base_dark" ]; then
        change_asset_color "color-base-dark" "${color_base_dark}"
    fi
    if [ "${aFlags[8]}" == "true" -a "${old_color_accent}" != "color_accent" ]; then
        change_asset_color "color-accent" "${color_accent}"
        change_asset_color "color-accent-disabled" "${color_accent}"
    fi
    print_assets_summary
    echo 
    echo "Assets color successfully changed, run '${0} render-assets' to generate new assets."
}
print_assets_summary () {
    printf "%-25s%-10s%-10s%-8s\n" "ASSETS COLOR" "OLD COLOR" "NEW COLOR" "OPACITY"
    printf "%-25s%-10s%-10s%-8s\n" "color-fg" "${old_color_fg}" "${color_fg}" "0.78"
    printf "%-25s%-10s%-10s%-8s\n" "color-fg-dark" "${old_color_fg_dark}" "$color_fg_dark" "1.0" 
    printf "%-25s%-10s%-10s%-8s\n" "color-fg2" "${old_color_fg_secondary}" "$color_fg" "0.54"
    printf "%-25s%-10s%-10s%-8s\n" "color-fg2-dark" "${old_color_fg_secondary_dark}" "$color_fg_dark" "0.7"
    printf "%-25s%-10s%-10s%-8s\n" "color-fg2-disabled" "${old_color_fg_secondary_disabled}" "$color_fg" "0.26"
    printf "%-25s%-10s%-10s%-8s\n" "color-fg2-disabled-dark" "${old_color_fg_secondary_disabled_dark}" "$color_fg_dark" "0.3"
    printf "%-25s%-10s%-10s%-8s\n" "color-bg" "${old_color_bg}" "${color_bg}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-bg-dark" "${old_color_bg_dark}" "${color_bg_dark}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-bg-lighter" "${old_color_bg_lighter}" "${color_bg_lighter}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-bg-lighter-dark" "${old_color_bg_lighter_dark}" "${color_bg_lighter_dark}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-base" "${old_color_base}" "${color_bg_base}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-base-dark" "${old_color_base_dark}" "${color_base_dark}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-divider" "${old_color_divider}" "${color_fg}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-divider-dark" "${old_color_divider_dark}" "${color_fg_dark}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-accent" "${old_color_accent}" "${color_accent}" "1.0"
    printf "%-25s%-10s%-10s%-8s\n" "color-accent-disabled" "${old_color_accent_disabled}" "${color_accent}" "0.5"
}
# Render asset
render_asset_gtk2 () {
    local assets_src_file=${1}
    local assets_dir=${2}
    local asset_name=${3}
    local gtk2_hidpi=$(echo ${GTK2_HIDPI-False} | tr '[:upper:]' '[:lower:]')
    local hidpi_option=""
    if [ "gtk2_hidpi" == "true" ]; then
        hidpi_option="--export-dpi=192"
    fi
    INKSCAPE=$(which inkscape)
    OPTIPNG=$(which optipng)
    
    if [ -f ${assets_dir}/${asset_name}.png ]; then
        echo "assets/${asset_name}.png exists."
    else
        echo Rendering assets/${asset_name}.png
        $INKSCAPE --export-id=${asset_name} --export-id-only ${hidpi_option} \
                  --export-background-opacity=0 \
                  --export-png="${assets_dir}/${asset_name}.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}.png
    fi
}
render_asset_gtk3 () {
    local assets_src_file=${1}
    local assets_dir=${2}
    local asset_name=${3}
    INKSCAPE=$(which inkscape)
    OPTIPNG=$(which optipng)
    
    if [ -f ${assets_dir}/${asset_name}.png ]; then
        echo "assets/${asset_name}.png exists."
    else
        echo Rendering assets/${asset_name}.png
        $INKSCAPE --export-id=${asset_name} --export-id-only \
                  --export-png="${assets_dir}/${asset_name}.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}.png
    fi
    if [ -f ${assets_dir}/${asset_name}@2.png ]; then
        echo "assets/${asset_name}@2.png exists."
    else
        echo Rendering assets/${asset_name}@2.png
        $INKSCAPE --export-id=${asset_name} --export-id-only --export-dpi=192 \
                  --export-png="${assets_dir}/${asset_name}@2.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}@2.png
    fi
}
# Rendering assets
render_assets () {
    if [ "$1" == "gtk3" ]; then
        if [ ! -d "$SRC_DIR/gtk-3.0/gtk-common/assets" ]; then
            mkdir -p "${SRC_DIR}/gtk-3.0/gtk-common/assets"
        elif [ ! -d "$SRC_DIR/gtk-3.0/gtk-common/assets_original" ]; then
            mv "$SRC_DIR/gtk-3.0/gtk-common/assets" "$SRC_DIR/gtk-3.0/gtk-common/assets_original"
        fi
        local assets_src_file="${SRC_DIR}/gtk-3.0/gtk-common/assets.svg"
        local assets_dir="${SRC_DIR}/gtk-3.0/gtk-common/assets"
        local assets_index="${SRC_DIR}/gtk-3.0/gtk-common/assets.txt"
    elif [ "$1" == "gtk2" ]; then
        if [ ! -d "$SRC_DIR/gtk-2.0/assets" ]; then
            mkdir -p "${SRC_DIR}/gtk-2.0/assets"
        elif [ ! -d "$SRC_DIR/gtk-2.0/assets_original" ]; then
            mv "$SRC_DIR/gtk-2.0/assets" "$SRC_DIR/gtk-2.0/assets_original"
        fi
        mkdir -p "${SRC_DIR}/gtk-2.0/assets"
        local assets_src_file="${SRC_DIR}/gtk-2.0/assets.svg"
        local assets_dir="${SRC_DIR}/gtk-2.0/assets"
        local assets_index="${SRC_DIR}/gtk-2.0/assets.txt"
    fi
    #install -d ${assets_dir}
    if [[ $(which parallel 2>/dev/null) ]]; then
        printf "\n%s\n\n" "Start rendering ..."
        export -f render_asset_${1}
        parallel --load 85% --noswap -a ${assets_index} render_asset_${1} ${assets_src_file} ${assets_dir} 
        unset -f render_asset_${1}
        printf "\n%s\n\n" "Finished rendering."
    else
        printf "\n%s\n" "We recommend installing 'parallel' for faster rendering"
        printf "%s\n" "Start rendering ..."
        while read i; do 
            render_asset_${1} ${assets_src_file} ${assets_dir} "${i}"
        done < ${assets_index}
        printf "\n%s\n\n" "We recommend installing 'parallel' for faster rendering"
        printf "%s\n" "Finished rendering ..."
    fi
}

# Arraies of flags to control the installation and rendering assets
iFlags=('false' 'false'  'false' 'false' 'false')       # installation flags 
aFlags=('false' 'false'  'false' 'false' 'false' \      # assets flags
        'false' 'false'  'false' 'false' 'false' \ 
        'false' 'false'  'false' 'false' 'false' \ 
        'false')
rFlags='false'                                          # rendering flag 

OPTS=$(getopt -o c:s:n:d: -l color:,size:,name:,assets:, render-assets,\
    fg:,fg-dark:,fg2:,fg2-dark:,fg2-disabled:,fg2-dark-disabled:,\
    bg:,bg-dark:,bg-lighter:,bg-lighter-dark:,base:,base-dark:,\
    divider:,divider-dark:,accent:,accent-dark:,dst: -n $0 -- "$@")

if [ $? -ne 0 ]; then
    echo "Failed parsing options, Try '$0 --help' for more info"
    exit 1
fi

if [ "${1}" == "install" ]; then
    shift
    while [ $# -gt 0 ] && [ "$1" != "--" ]; do 
        case "$1" in
            -c|--color)
                color="-${2}"
                is_valid_variant "${color}" 
                iFlags[0]='true'
                shift 2
                ;;
            -s|--size)
                size="-${2}"
                is_valid_size "${size}" 
                iFlags[1]='true'
                shift 2
                ;;
            -n|--name)
                new_theme_name="${2}"
                iFlags[2]='true'
                shift 2
                ;;
            -h|--help)
                usage
                shift 2
                exit 1
                ;;
            -d|--dst)
                #TODO: prompt the user to run as root when outside $HOME 
                theme_dst_dir="${2}"
                if [ ! -d "${theme_dst_dir}" ]; then
                    echo "ERROR: destination directory does not exist."
                    exit 1
                fi
                iFlags[3]='true'
                shift 2
                ;;
            *)
                echo "ERROR: Unsupported argument '$1'."
                echo "Try '$0 --help' for more information"
                exit 1
                ;;
        esac
    done
    set_theme_variant ${color} ${size}
    install_materia  ${theme_dst_dir}
    echo
elif [ "${1}" == "assets" ]; then
    shift
    while [ $# -gt 0 ] && [ "$1" != "--" ]; do
        case "$1" in 
            --fg)
                is_valid_color "${1}" "${2}"
                color_fg=${2:-"#000000"}
                old_color_fg=
                aFlags[0]='true'
                shift 2
                ;;
            --fg-dark)
                is_valid_color "${1}" "${2}"
                color_fg_dark=${2:-"#FFFFFF"}
                aFlags[1]='true'
                shift 2
                ;;
            --bg)
                is_valid_color "${1}" "${2}"
                color_bg=${2:-"#F5F5F5"}
                aFlags[2]='true'
                shift 2
                ;;
            --bg-dark)
                is_valid_color "${1}" "${2}"
                color_bg_dark=${2:-"#333E43"}
                aFlags[3]='true'
                shift 2
                ;;
            --bg-lighter)
                is_valid_color "${1}" "${2}"
                color_bg_lighter=${2:-"#FAFAFA"}
                aFlags[4]='true'
                shift 2
                ;;
            --bg-lighter-dark)
                is_valid_color "${1}" "${2}"
                color_bg_lighter_dark=${2:-"#414F56"}
                aFlags[5]='true'
                shift 2
                ;;
            --base)
                is_valid_color "${1}" "${2}"
                color_base=${2:-"#FFFFFF"}
                aFlags[6]='true'
                shift 2
                ;;
            --base-dark)
                is_valid_color "${1}" "${2}"
                color_base_dark=${2:-"#3B484E"}
                aFlags[7]='true'
                shift 2
                ;;
            --accent)
                is_valid_color "${1}" "${2}"
                color_accent=${2:-"#FF4081"}
                aFlags[8]='true'
                shift 2
                ;;
            *)
                echo "ERROR: Unrecognized assets option '$1'"
                exit 1
                ;; 
        esac
    done
    change_assets_color
    echo
elif [ "${1}" == "render-assets" ]; then
    shift
    while [ $# -ne 0 ] && [ "$1" != "--" ]; do
        case "$1" in
            --gtk2)
                render_assets "gtk2"
                shift 
                ;;
            --gtk3)
                render_assets "gtk3"
                shift
                ;;
            *)
                echo "ERROR: Unrecognized rendering option '$1'."
                echo "Try '$0 --help' for more information"
                exit 1
                ;; 
        esac
    done
elif [ "${1}" == "--help" -o "${1}" == "-h" ]; then
    usage

    echo "Try '${0} --help' for more information."
fi
exit 0
