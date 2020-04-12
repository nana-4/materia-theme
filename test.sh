#!/bin/bash
#
# Create a snapshot for comparison with the latest development version.
#
set -ueo pipefail

BUILD_DIR="build_snapshot"
PREFIX="$HOME/.local"
THEME_NAME="MateriaSnapshot"

if [[ -d "$BUILD_DIR" ]]; then
  meson "$BUILD_DIR" --prefix="$PREFIX" -Dtheme_name="$THEME_NAME" --reconfigure
else
  meson "$BUILD_DIR" --prefix="$PREFIX" -Dtheme_name="$THEME_NAME"
fi
ninja -C "$BUILD_DIR" install
