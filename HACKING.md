## Summary

- Do not edit the CSS directly, edit the source SCSS files and run `./parse-sass.sh`
- To be able to use the latest/adequate version of Sass, install `sassc`
- To change the SVG assets color, use a text editor instead of a image editor

## How to tweak the theme

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
  minimum. It covers both the light variant and the dark variant.

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

## How to change the assets color

To keep it maintainable, SVG files are basically edited on text-based.

So if you just want to change the SVG assets color, we recommend using a
**text editor** instead of **Inkscape**. However, please note that Inkscape is
required to render the PNG assets from the SVG files.

Here's an example to change the _accent color_:

1. Open the following SVG files with a **text editor**.

  - `./src/gtk-2.0/assets.svg`
  - `./src/gtk-2.0/assets-dark.svg`
  - `./src/gtk/assets.svg`
  - `./src/gnome-shell/3.18/assets/checkbox.svg`
  - `./src/gnome-shell/3.18/assets/more-results.svg`
  - `./src/gnome-shell/3.18/assets/toggle-on.svg`
  - `./src/gnome-shell/3.18/assets-dark/checkbox.svg`
  - `./src/gnome-shell/3.18/assets-dark/more-results.svg`
  - `./src/gnome-shell/3.18/assets-dark/toggle-on.svg`

2. Search `#FF4081` (default accent color) and replace with your favorite color.

  > The recommended color palette is: https://material.io/guidelines/style/color.html#color-color-palette

3. Run `./render-assets.sh` to render the PNG assets for gtk2 and gtk3.

  > Note: `inkscape` and `optipng` must be installed to run the script.

## Changing the color scheme with script

To easily change the color scheme, you can use the `change_color.sh` script (or
just use the [oomox](https://github.com/actionless/oomox) app).

Originally `change_color.sh` (and the `scripts/` dir) was implemented for oomox,
but you can also run it on the command line without oomox like this:

> Note: This script only supports GTK2 and GTK3 for now.

For `bash`:

```bash
./change_color.sh -o my-test-theme <(echo -e "BG=F5F5F5\nFG=000000\nMENU_BG=FFFFFF\nMENU_FG=000000\nSEL_BG=42A5F5\nSEL_FG=FFFFFF\nTXT_BG=FFFFFF\nTXT_FG=000000\nBTN_BG=FAFAFA\nBTN_FG=000000\nACCENT_BG=FF4081\n")
```

For `fish`:

```fish
./change_color.sh -o my-test-theme (echo -e "BG=F5F5F5\nFG=000000\nMENU_BG=FFFFFF\nMENU_FG=000000\nSEL_BG=42A5F5\nSEL_FG=FFFFFF\nTXT_BG=FFFFFF\nTXT_FG=000000\nBTN_BG=FAFAFA\nBTN_FG=000000\nACCENT_BG=FF4081\n" | psub)
```

## Useful Links

#### Upstream theme sources

- [GTK+ 4.0](https://gitlab.gnome.org/GNOME/gtk/tree/master/gtk/theme/Adwaita) (master)
  - [3.22](https://gitlab.gnome.org/GNOME/gtk/tree/gtk-3-22/gtk/theme/Adwaita)
  - [3.20](https://gitlab.gnome.org/GNOME/gtk/tree/gtk-3-20/gtk/theme/Adwaita)
  - [3.18](https://gitlab.gnome.org/GNOME/gtk/tree/gtk-3-18/gtk/theme/Adwaita)
- [GTK+ 2](https://gitlab.gnome.org/GNOME/gnome-themes-extra/tree/master/themes/Adwaita/gtk-2.0)
- [GNOME Shell](https://gitlab.gnome.org/GNOME/gnome-shell/tree/master/data/theme)
  - [Sass sources](https://github.com/GNOME/gnome-shell-sass) (legacy)
- [Metacity](https://gitlab.gnome.org/GNOME/gnome-themes-extra/tree/gnome-3-14/themes/Adwaita/metacity-1) (legacy)

> For other upstream theme sources of apps/DEs, see the comments in the source code.

#### Tips

- [Material Design Guidelines](https://www.material.io/guidelines/)
- [CSS Guidelines for Materia](https://github.com/nana-4/materia-theme/wiki/CSS-Guidelines)
- [The GTK+ Inspector](https://blog.gtk.org/2017/04/05/the-gtk-inspector/)
- [Theming in GTK+ 4](https://developer.gnome.org/gtk4/stable/theming.html)
- [Theming in GTK+ 3](https://developer.gnome.org/gtk3/stable/theming.html)
- [GTK+ 2 Theming Tutorial](https://wiki.gnome.org/Attic/GnomeArt/Tutorials/GtkThemes)
- [The Pixmap Engine](https://wiki.gnome.org/Attic/GnomeArt/Tutorials/GtkEngines/PixmapEngine)
- [Designing Metacity Themes](https://wiki.gnome.org/Attic/GnomeArt/Tutorials/MetacityThemes)
- [Unity/Theming](https://wiki.ubuntu.com/Unity/Theming)
- [Xfwm4 theme how-to](https://wiki.xfce.org/howto/xfwm4_theme)
- [Chrome Themes](https://developer.chrome.com/extensions/themes)
