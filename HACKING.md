Summary
-------

- Do not edit the CSS directly, edit the source SCSS files and run `./parse-sass.sh`
- To be able to use the latest/adequate version of Sass, install `sassc`
- To change the SVG assets color, use a text editor instead of a image editor

How to tweak the theme
----------------------

Like the upstream Adwaita, this theme is written and processed in Sass.

You can read about Sass at http://sass-lang.com/documentation/. Once you make
your changes to the SCSS files, run the `./parse-sass.sh` script to rebuild the
CSS files.

Here's a rundown of the _supporting_ stylesheets:

- `_variables.scss`

  variables to allow easier definition of widget sizing/styling.

- `_color-palette.scss`

  material design color palette definitions. We don't recommend editing this
  unless Google updates the color scheme.

- `_colors.scss`

  global color definitions. We keep the number of defined colors to a necessary
  minimum, most colors are derived from a handful of basics. It covers both the
  light variant and the dark variant.

- `_colors-public.scss`

  SCSS colors exported through gtk to allow for 3rd party apps color mixing.

- `_drawing.scss`

  drawing helper mixings/functions to allow easier definition of widget drawing
  under specific context.

- `_common.scss`

  actual definitions of style for each widget. This is where you are likely to
  add/remove your changes.

- `_apps.scss` or `_extensions.scss`

  app/extension specific stylings.

How to change the assets color
------------------------------

To keep it maintainable, SVG files are basically edited on text-based.

So if you just want to change the SVG assets color, we recommend using a
**text editor** instead of **Inkscape**. However, please note that Inkscape is
required to render the PNG assets from the SVG files.

Here's an example to change the _accent color_:

1. Open the following SVG files with a **text editor**.

  - `./src/gtk-2.0/assets.svg`
  - `./src/gtk-2.0/assets-dark.svg`
  - `./src/gtk-3.0/gtk-common/assets.svg`
  - `./src/gnome-shell/3.18/assets/checkbox.svg`
  - `./src/gnome-shell/3.18/assets/more-results.svg`
  - `./src/gnome-shell/3.18/assets/toggle-on.svg`
  - `./src/gnome-shell/3.18/assets-dark/checkbox.svg`
  - `./src/gnome-shell/3.18/assets-dark/more-results.svg`
  - `./src/gnome-shell/3.18/assets-dark/toggle-on.svg`

2. Search `#FF4081` (default accent color) and replace with your favorite color.

  - The recommended color palette is: https://material.io/guidelines/style/color.html#color-color-palette

3. For gtk2 and gtk3, delete all PNG assets before redrawing them.

  ```sh
  rm -v ./src/gtk-2.0/assets/*.png
  rm -v ./src/gtk-2.0/assets-dark/*.png
  rm -v ./src/gtk-3.0/gtk-common/assets/*.png
  ```

4. Run `./render-assets.sh` or `./render-assets-dark.sh` to render the PNG assets.

  > Note: Inkscape must be installed to run the scripts.

  - for gtk2:

    ```sh
    cd ./src/gtk-2.0
    ./render-assets.sh
    ./render-assets-dark.sh
    ```

  - for gtk3:

    ```sh
    cd ./src/gtk-3.0/gtk-common
    ./render-assets.sh
    ```

Useful Links
------------

Upstream theme sources:
- [GTK+ 4](https://github.com/GNOME/gtk/tree/master/gtk/theme/Adwaita)
  - [3.22](https://github.com/GNOME/gtk/tree/gtk-3-22/gtk/theme/Adwaita)
  - [3.20](https://github.com/GNOME/gtk/tree/gtk-3-20/gtk/theme/Adwaita)
  - [3.18](https://github.com/GNOME/gtk/tree/gtk-3-18/gtk/theme/Adwaita)
- [GTK+ 2](https://github.com/GNOME/gnome-themes-standard/tree/master/themes/Adwaita/gtk-2.0)
- [GNOME Shell](https://github.com/GNOME/gnome-shell/tree/master/data/theme)
  - [Sass sources](https://github.com/GNOME/gnome-shell-sass)

Tips:
- [Unity/Theming](https://wiki.ubuntu.com/Unity/Theming)
- [Material Design Guidelines](https://www.material.io/guidelines/)
- [Personal CSS Guidelines](https://github.com/nana-4/Flat-Plat/wiki/CSS-Guidelines)
