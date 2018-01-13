#!/bin/env bash
set -e
if [ $# -eq 0 ]; then
    echo "$0: missing argument"
    echo "Try '$0 --help' for more information."
    exit 1
fi
DEST_DIR=/usr/share/themes
GTK_VER=('3.18' '3.20' '3.22')
GS_VER=(3.18 3.20 3.22 3.24 3.26)
COLOR_VARIANTS=('' '-dark' '-light')
SIZE_VARIANTS=('' '-compact')

usage() {
    printf "%s\n" "Usage: $0 install [OPTIONS...] [DEST-DIR]"
    printf "\n%s\n" "OPTIONS:"
    printf "  %-20s%s\n" "-c, --color" "Specify theme color variant [dark|light] (Default to ALL variants)"
    printf "  %-20s%s\n" "-s, --size" "Specify theme size variant [compact] (Default to ALL sizes)"
    printf "  %-20s%s\n" "-n, --name" "Specify theme name (Default to Materia-color-size)"
    printf "  %-20s%s\n" "-d, --dest" "Specify theme destination directory (Default to ${DEST_DIR})"
    printf "  %-20s%s\n" "-h, --help" "Show this help"
    printf "%s\n" "INSTALLATION EXAMPLES:"
    printf "%s\n" "Install all theme variants with default name"
    printf "\t%s\t%s\n" "./materia install" 
    printf "%s\n" "Install all theme variants with different name"
    printf "\t%s\t%s\n" "./materia install -n mytheme"
    printf "%s\n" "Install one theme variant with both sizes"
    printf "\t%s\t%s\n" "./materia install --color dark"
    printf "\t%s\t%s\n" "./materia install --color light"
    printf "%s\n" "Install all compact variants"
    printf "\t%s\t%s\n" "./materia install --size compact"
    printf "%s\n" "Install only one specific theme variant"
    printf "\t%s\t%s\n" "./materia install --color light --size compact"
    printf "\t%s\t%s\n" "./materia install --color light --size compact -n mytheme"
}
# Get gnome-shell version
latest_gs_ver=${GS_VER[@]: -1}
if [[ $(which gnome-shell 2> /dev/null) ]]; then
    GS_VER=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 1,2)
    for ver in "${GS_VER[@]}"; do
        if (( $(echo "$ver >= $GS_VER"|bc -l) )); then
            GS_VER=${ver}
            break
        elif (( $(echo "$GS_VER > $latest_gs_ver"|bc -l) )); then
            GS_VER=$latest_gs_ver
            break
        fi
    done
else
    GS_VER=3.18
fi
# Clean up
remove_materia () {
    if [ -d "${1}" ]; then
        rm -rf ${1}
    fi
}
# Validate theme variant  
is_valid_variant () {
    if [[ ! " ${COLOR_VARIANTS[@]} " =~ " $1 " ]]; then
        echo "ERROR: Unsupported color variant '"${1:1}"'."
        echo "Try '$0 --help' for more inforamtion."
        exit 1
    fi
}
# Validate theme size 
is_valid_size () {
    if [[ ! " ${SIZE_VARIANTS[@]} " =~ " $1 " ]]; then
        echo "ERROR: Unsupported size variant '"${1:1}"'."
        echo "Try '$0 --help' for more inforamtion."
        exit 1
    fi
}
# Set theme name
set_theme_name () {
    if [[ "${iFlags[2]}" = "false" ]]; then
        theme_name=Materia$1$2
    elif [[ "${iFlags[0]}" == "true" && "${iFlags[1]}" == "true" && "${iFlags[2]}" == "true" ]]; then
        theme_name="${new_theme_name}"
    else
        theme_name="${new_theme_name}"$1$2
    fi
}
# Set specific theme variant(s) default to ALL
set_theme_variant () {
    if [ "${iFlags[0]}" == "false" -a "${iFlags[1]}" == "false" ]; then
        theme_color=("${COLOR_VARIANTS[@]}")
        theme_size=("${SIZE_VARIANTS[@]}")
    elif [ "${iFlags[0]}" == "true" -a "${iFlags[1]}" == "false" ]; then
        theme_color="$1"
        theme_size=("${SIZE_VARIANTS[@]}")
    elif [ "${iFlags[0]}" == "false" -a "${iFlags[1]}" == "true" ]; then
        theme_color=("${COLOR_VARIANTS[@]}")
        theme_size="$2"
    else
        theme_color="$1"
        theme_size="$2"
    fi
}
# Install gnome-shell theme 
install_gnome_shell () {
    gs_src_dir=src/gnome-shell/${GS_VER}
    gs_dst_dir="${3}/gnome-shell"
    install -d "${gs_dst_dir}"
    cp -ur ${gs_src_dir}/*.svg ${gs_dst_dir}
    cp -urL ${gs_src_dir}/{extensions,pad-osd.css,noise-texture.png} ${gs_dst_dir}
    if [ "${1}" != "-dark" ]; then
        cp -urL ${gs_src_dir}/assets ${gs_dst_dir}
    else
        cp -urL ${gs_src_dir}/assets-dark ${gs_dst_dir}/assets
    fi
    cp "${gs_src_dir}/gnome-shell${1}${2}.css" "${gs_dst_dir}/gnome-shell.css"
    # Create a binary resource bundle from .gresource.xml
    glib-compile-resources \
        --sourcedir=${gs_dst_dir} \
        --target=${gs_dst_dir}/gnome-shell-theme.gresource \
        ${gs_src_dir}/gnome-shell-theme.gresource.xml
}
# Install GTK+ 2 theme
install_gtk2_theme () {
    install -d "${3}/gtk-2.0"
    cp -ur src/gtk-2.0/{apps,hacks,main}.rc ${3}/gtk-2.0
    cp -ur src/gtk-2.0/gtkrc${1} ${3}/gtk-2.0/gtkrc
    if [ "${1}" == "-dark" ]; then
        cp -ur src/gtk-2.0/assets${1} ${3}/gtk-2.0/assets
    else
        cp -ur src/gtk-2.0/assets ${3}/gtk-2.0
    fi
}
# Install GTK+ 3 theme 
install_gtk3_theme () {
    install -d "${3}/gtk-common"
    cp -ur src/gtk-3.0/gtk-common/assets ${3}/gtk-common
    for ver in "${GTK_VER[@]}"; do 
        if [ "${ver}"  == "3.18" ]; then
            install -d "${3}/gtk-3.0"
            cp -ur src/gtk-3.0/${ver}/assets ${3}/gtk-3.0
            cp -ur src/gtk-3.0/${ver}/gtk${1}.css ${3}/gtk-3.0/gtk.css 
        else
            install -d "${3}/gtk-${ver}"
            cp -ur src/gtk-3.0/${ver}/assets ${3}/gtk-${ver}
            cp -ur src/gtk-3.0/${ver}/gtk${1}${2}.css ${3}/gtk-${ver}/gtk.css
            if [ "${1}" != "-dark" ]; then
                cp "src/gtk-3.0/${ver}/gtk-dark${2}.css" "${3}/gtk-${ver}/gtk-dark.css" 
            fi
        fi
    done
}
# Installing Metacity theme
install_metacity_theme () {
    install -d "${3}/metacity-1"
    cp -ur src/metacity-1/assets ${3}/metacity-1 
    if [ "${1}" != "-light" ]; then
        cp -ur src/metacity-1/metacity-theme-{2,3}.xml ${3}/metacity-1 
    else
        cp -ur src/metacity-1/metacity-theme-2${1}.xml ${3}/metacity-1/metacity-theme-2.xml 
        cp -ur src/metacity-1/metacity-theme-3${1}.xml ${3}/metacity-1/metacity-theme-3.xml 
    fi
}
# Installing Unity theme
install_unity_theme () {
    install -d "${3}/unity"
    cp -ur src/unity/*.{svg,png,json} ${3}/unity
    if [ "${1}" != "-light" ]; then
        cp -ur src/unity/assets ${3}/unity 
    else
        cp -urT src/unity/assets${1} ${3}/unity/assets 
    fi
}
# Installing Xfwm theme
install_xfwm_theme () {
    install -d ${3}/xfwm4
    cp -ur src/xfwm4/{*.svg,themerc} ${3}/xfwm4
    if [ "${1}" != "-light" ]; then
        cp -ur src/xfwm4/assets ${3}/xfwm4 
    else
        cp -urT src/xfwm4/assets${1} ${3}/xfwm4/assets 
    fi
}
# Install Chrome theme
install_chrome_theme () {
    install -d ${3}/chrome
    cp -ur "src/chrome/Materia${color} Theme.crx" ${3}/chrome
    if [ "${1}" != "-dark" ]; then
        cp -ur "src/chrome/Materia Scrollbars.crx" ${3}/chrome
    else
        cp -ur "src/chrome/Materia${color} Scrollbars.crx" ${3}/chrome
    fi
}
# Main function
install_materia () {
    for color in "${theme_color[@]}"; do 
        for size in "${theme_size[@]}"; do
            set_theme_name ${color} ${size}
            theme_dir=${1:-${DEST_DIR}}/${theme_name}
            remove_materia "${theme_name}"
            install -d "${theme_dir}"
            cp -ur COPYING ${theme_dir}
            cp -ur src/index${color}${size}.theme ${theme_dir}
            printf "%s\n" "Installing $theme_name ... " 
            install_gtk2_theme "${color}" "${size}" "${theme_dir}"
            install_gtk3_theme "${color}" "${size}" "${theme_dir}"
            install_gnome_shell "${color}" "${size}" "${theme_dir}" "${theme_name}"
            install_metacity_theme "${color}" "${size}" "${theme_dir}"
            install_unity_theme "${color}" "${size}" "${theme_dir}"
            install_xfwm_theme "${color}" "${size}" "${theme_dir}"
            install_chrome_theme "${color}" "${size}" "${theme_dir}"
       done
   done
}
# Arraies of flags to control the installation flow
iFlags=('false' 'false'  'false' 'false' 'false')      # installation flags 
OPTS=$(getopt -o c:s:n:d:h -l color:,size:,name:,dest:,help, -n $0 -- "$@")
if [ $? -ne 0 ]; then
    echo "Failed parsing options, Try '$0 --help' for more information"
    exit 1
fi

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
        -d|--dest)
            theme_dst_dir="${2}"
            if [ ! -d "${theme_dst_dir}" ]; then
                echo "ERROR: destination directory does not exist."
                exit 1
            fi
            iFlags[3]='true'
            shift 2
            ;;
        -h|--help)
            usage
            shift 2
            exit 1
            ;;
        *)
            echo "ERROR: Unrecognized installation option '$1'."
            echo "Try '$0 --help' for more information"
            exit 1
            ;;
    esac
done
if [ "${iFlags[3]}" == "false" -a $(id -u) != 0 ]; then
    echo "Please run as root." 
    exit 1
fi
set_theme_variant "${color}" "${size}"
install_materia  ${theme_dst_dir}
echo "Done!"
exit 0
