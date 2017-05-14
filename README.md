Flat-Plat
=========
Flat-Plat is a [Material Design](https://material.io)-like theme for GNOME/GTK+ based desktop environments.  
It supports GTK3, GTK2, Metacity, GNOME Shell, Unity, MATE, LightDM, GDM, Chrome theme, etc.

Features
--------
<img src="../images/Button.gif" alt="Button" align="right"/>

- Supports ripple effect animations (only GTK3 apps).
- Supports both light and dark variants.
- Supports dark or light titlebar versions.
- Supports compact version for low resolution.
- Supports [Dash to Dock](https://github.com/micheleg/dash-to-dock) extension's theming.
- Supports [Workspaces to Dock](https://github.com/passingthru67/workspaces-to-dock) extension's theming.
- Supports Chrome/Chromium theme and scrollbars extension.
- Appears more beautifully when you use a font family including `Medium` and `Light` weights.

Requirements
------------
- GTK+ 3.18 or later
- `gnome-themes-standard`
- pixmap (or pixbuf) engine
- murrine engine

##### Supported desktop environments are:
- GNOME Shell 3.18 or later
- Unity 7.4 or later
- MATE 1.14 or later

Installation
------------
Arch Linux users can install from the [AUR package](https://aur.archlinux.org/packages/flatplat-theme) maintained by @cthbleachbit.

Fedora and EPEL users can also install from a [Copr repository](https://copr.fedorainfracloud.org/coprs/tcg/themes/).

### Manual Installation
1. Open the terminal and run the following commands:

  ```sh
  cd /tmp
  curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170323.tar.gz | tar xz
  cd Flat-Plat-20170323 && sudo ./install.sh
  ```

2. Select the theme using `gnome-tweak-tool` or other suitable tools.

3. Optionally;
  - Set the font size to `9.75` (= 13px at 96dpi) or `10.5` (= 14px at 96dpi).
  - Open the `chrome` folder on `/usr/share/themes/Flat-Plat`* and drag and drop the `.crx` files onto the Chrome/Chromium _Extensions_ page.

### Manual Uninstallation
- Delete the installed directories.

  ```sh
  sudo rm -rf /usr/share/themes/Flat-Plat{,-compact,-dark,-dark-compact,-light,-light-compact}
  ```

GDM (Lock/Login Screen)
-----------------------
You can change the GDM theme by replacing the default GNOME Shell theme.  
However, if it fails, the desktop environment may not operate correctly. So please **be careful** if doing this.

#### :warning: Cautions:
- When applying this, other third-party GNOME Shell themes would look broken until you restore to the original theme.
- If GNOME Shell has been updated, it will be restored to the original theme, so you will need to install this again.

### Installation
1. First select the GTK+ theme, then back up and replace the existing `.gresource` file.

  ```sh
  GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
  sudo cp -iv --backup /usr/share{/themes/$GTK_THEME,}/gnome-shell/gnome-shell-theme.gresource
  ```

  > _Developer note:_  
  > If you don't want to overwrite the backup on the second and subsequent runs, delete the `--backup` option.

2. Restart GNOME Shell. (If you are running _GNOME on Xorg_, press <kbd>Alt</kbd> + <kbd>F2</kbd> then type `r`.)

### Uninstallation
1. Restore to the original theme from the backup.

  ```sh
  sudo mv -iv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
  ```

2. Restart GNOME Shell. (If you are running _GNOME on Xorg_, press <kbd>Alt</kbd> + <kbd>F2</kbd> then type `r`.)

Screenshots
-----------
##### GNOME Shell 3.20
![GNOME Shell 3.20](../images/Screenshot1.png?raw=true)
##### Unity 7.4
![Unity 7.4](../images/Screenshot2.png?raw=true)
##### GDM Lock Screen
![GDM Lock Screen](../images/Screenshot3.png?raw=true)
##### GDM Unlock Screen
![GDM Unlock Screen](../images/Screenshot4.png?raw=true)
<sub>**Screenshots Details:** Icons: [Paper](https://github.com/snwh/paper-icon-theme) | Font: [M+ 1C](https://mplus-fonts.osdn.jp) 10.5pt | Dock's icon size: 48px + fixed | [Wallpapers](http://imgur.com/a/v2Ovx)</sub>

Contributing
------------
If you find any bugs or mistakes, please report it to the [issue tracker](https://github.com/nana-4/Flat-Plat/issues) or send a pull request.  
Any contribution will be much appreciated.

Planned Features
----------------
- Supports of Xfce theme
- Supports of Firefox theme ([in progress](https://github.com/nana-4/Flat-Plat/issues/78))
- Supports of overlay scrollbars for Chrome/Chromium extension
- GNOME Terminal color pallet (if possible)
- Material Design like cursor theme

License
-------
Flat-Plat is distributed under the terms of the GNU General Public License, version 2 or later. See the [`COPYING`](COPYING) file for details.

Credits
-------
- This theme is based on [Adwaita](HACKING.md#useful-links) by GNOME.
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
- The original concept is Google's [Material Design](https://material.io).

Also thank you for every upstream developers and all contributors.
