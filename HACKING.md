Summary
-------

- Do not edit the CSS directly, edit the source SCSS files and process them with SASS (run 
  `./parse-sass.sh` when you have the required software installed, as described below)

- To be able to use the latest/adequate version of sass, install ruby, gem, sass & bundle.
  On Fedora 25, this is done with `sudo dnf install rubygems && gem install bundle && bundle install`
  from the same directory this `HACKING.md` resides in.

How to tweak the theme
----------------------

Flat-Plat is a complex theme, so to keep it maintainable it's written and processed in SASS.

It is very likely your change will happen in the `_common.scss` file. That's where all the widget 
selectors are defined. Here's a rundown of the "supporting" stylesheets, that are unlikely to be the 
right place for a drive by stylesheet fix:

- `_colors.scss`

  global color definitions. We keep the number of defined colors to a necessary minimum, 
  most colors are derived form a handful of basics. It covers both the light variant and
  the dark variant.

- `_colors-public.scss`

  SCSS colors exported through gtk to allow for 3rd party apps color mixing.

- `_drawing.scss`

  drawing helper mixings/functions to allow easier definition of widget drawing under
  specific context. This is why Flat-Plat isn't 15000 LOC.

- `_common.scss`

  actual definitions of style for each widget. This is where you are likely to add/remove your changes.

You can read about SASS at http://sass-lang.com/documentation/. Once you make your changes to the
`_common.scss` file, you can either run the `./parse-sass.sh` script or keep SASS watching for changes as you
edit. This is done by running `bundle exec sass --watch --sourcemap=none .` If sass is out of date, or is
missing, you can install it with `bundle install`.

How to change the assets color
------------------------------

To keep it maintainable SVG files are basically edited on text-based.

So if you just want to change the SVG assets color, I recommend using a **text editor** instead of **Inkscape**.
But please note that in some cases Inkscape is needed to render PNG assets.

Here is an example to change the _accent color_:

1. Open the following `.svg` files with a **text editor**.

  - ./src/gtk-2.0/assets.svg
  - ./src/gtk-2.0/assets-dark.svg
  - ./src/gtk-3.0/gtk-common/assets.svg
  - ./src/gnome-shell/3.18/assets/checkbox.svg
  - ./src/gnome-shell/3.18/assets/more-results.svg
  - ./src/gnome-shell/3.18/assets/toggle-on.svg
  - ./src/gnome-shell/3.18/assets-dark/checkbox.svg
  - ./src/gnome-shell/3.18/assets-dark/more-results.svg
  - ./src/gnome-shell/3.18/assets-dark/toggle-on.svg

2. Search `#FF4081` (default accent color) and replace with your favorite color.

  - The recommended color palette is: https://material.io/guidelines/style/color.html#color-color-palette

3. For gtk2 and gtk3, delete all png assets before redrawing them.

  ```sh
  rm -v ./src/gtk-2.0/assets/*.png
  rm -v ./src/gtk-2.0/assets-dark/*.png
  rm -v ./src/gtk-3.0/gtk-common/assets/*.png
  ```

4. Render png assets with scripts. (Inkscape is required to run the scripts.)

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
  - [3.22.x](https://github.com/GNOME/gtk/tree/gtk-3-22/gtk/theme/Adwaita)
  - [3.20.x](https://github.com/GNOME/gtk/tree/gtk-3-20/gtk/theme/Adwaita)
  - [3.18.x](https://github.com/GNOME/gtk/tree/gtk-3-18/gtk/theme/Adwaita)
- [GTK+ 2](https://github.com/GNOME/gnome-themes-standard/tree/master/themes/Adwaita/gtk-2.0)
- [GNOME Shell](https://github.com/GNOME/gnome-shell/tree/master/data/theme)
  - [Sass sources](https://github.com/GNOME/gnome-shell-sass)

Tips:
- [Unity/Theming](https://wiki.ubuntu.com/Unity/Theming)
- [Material Design Guidelines](https://www.material.io/guidelines/)
- [Personal CSS Guidelines](https://github.com/nana-4/Flat-Plat/wiki/CSS-Guidelines)
