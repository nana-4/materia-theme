#!/usr/bin/env bash
#
# Create a snapshot for comparison with the latest development version.
#
set -ueo pipefail

BUILD_DIR="_build_snapshot"
THEME_NAME="MateriaSnapshot"

if [[ ! -d "$BUILD_DIR" ]]; then
  meson "$BUILD_DIR" -Dtheme_name="$THEME_NAME"
fi
meson install -C "$BUILD_DIR"
