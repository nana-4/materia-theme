## General

- Improve directory structure (`help wanted`, ideas very welcome)

  - I'd like to simplify complicated directory structure and symbolic links.

  - Especially for Sass. Two `_colors.scss` should be lumped together and all CSSs need to reference it.

- Use `make` or `meson` for building? (`help wanted`)

- Improve `install.sh` script? (PRs very welcome)

  Currently, `install.sh` allows such arguments (thanks to @actionless):

  ```sh
  # This will install only normal color variant of compact theme into ~/.themes dir as MyTheme,
  # ie ~/.themes/MyTheme-compact
  COLOR_VARIANTS="," SIZE_VARIANTS="-compact" THEME_DIR_BASE=~/.themes/MyTheme ./install.sh
  ```

  My alternative idea is (more like shell option):

  ```sh
  # Note that this is just a draft.
  ./install.sh --color - --size compact --dir ~/.themes --name MyTheme
  # and/or shorter
  ./install.sh -c - -s compact -d ~/.themes -n MyTheme
  ```

## Supports

- Firefox theme ([#78](../../issues/78))

  - waiting for [the upstream to provide next-gen themes](https://blog.mozilla.org/addons/2017/02/24/improving-themes-in-firefox/)

  - Or, is it unnecessary because the new interface is well integrated with this theme?

- Xfce theme ([#60](../../issues/60), [#61](../../issues/61), [#92](../../issues/92))

  - waiting for the upstream to complete `gtk3` port

- Pantheon theme ([#69](../../issues/69))

- KDE theme ([#143](../../issues/143), `low priority`)

- GtkSourceView theme ([#150](../../issues/150))

- Color scheme for GNOME Terminal (if possible, `help wanted`)

- Overlay scrollbars extension for Chrome/Chromium (`low priority`)

- Cursor theme like Material Design (`low priority`)

## UI changes

- Make gtk2 check/radio buttons a bit smaller for Qt apps ([#78](../../issues/78))

- Use `#757575` as check/radio buttons color for only web interfaces ([#123](../../issues/123), if possible)

- Make compact variant more compact ([#79](../../issues/79))

- Use lighter background color for popups such as menu in dark variant

- Rework the focus state styles

## Others

- Polish Inkscape styling

- Polish Xfwm styling

- Use gtk3 color vars for `metacity-theme-3.xml`
