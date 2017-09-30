Flat-Plat
=========
Flat-Plat is a [Material Design](https://material.io)-like theme for GNOME/GTK+ based desktop environments.  
It supports GTK+ 3, GTK+ 2, GNOME Shell, Budgie, MATE, Unity, LightDM, GDM, Chrome theme, etc.

Also Flat-Plat has compatibility with [oomox](https://github.com/actionless/oomox).

Features
--------
<img src="../images/Button.gif" alt="Button" align="right"/>

- Supports ripple effect animations for GTK+ 3.
- Supports both light and dark variants.
- Supports dark and light titlebar variants.
- Supports compact variant for low resolution.

Requirements
------------
- GTK+ `>=3.18`
- `gnome-themes-standard`
- murrine engine

#### Supported desktop environments
- GNOME Shell `>=3.18`
- Budgie `>=10.2.5`
- MATE `>=1.14`
- Unity `>=7.4`

#### Build dependency
- `glib2` on Arch Linux
- `glib2-devel` on Fedora, openSUSE, etc
- `libglib2.0-dev` on Debian, Ubuntu, etc

Installation
------------
For **Arch Linux**, the [AUR package](https://aur.archlinux.org/packages/flatplat-theme) maintained by @cthbleachbit is available.

```sh
sudo yaourt -S flatplat-theme
```

For **Fedora** or **EPEL**, the [Copr repository](https://copr.fedorainfracloud.org/coprs/tcg/themes/) maintained by @LaurentTreguier is available.

```sh
sudo dnf copr enable tcg/themes
sudo dnf install Flat-Plat-theme
```

#### Manual Installation
Run the following commands in the terminal.

```sh
cd /tmp && curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170917.tar.gz | tar xz
cd Flat-Plat-20170917
sudo ./install.sh
```

#### Manual Uninstallation
Delete the installed directories.

```sh
sudo rm -rf /usr/share/themes/Flat-Plat{,-compact,-dark,-dark-compact,-light,-light-compact}
```

Recommendations
---------------
#### Font
- To properly display the theme, use a font family including `Medium` weight (like [Roboto](https://github.com/google/roboto) or [M+](https://mplus-fonts.osdn.jp)).
- Set the font size to `9.75` (= 13px at 96dpi) or `10.5` (= 14px at 96dpi).

#### Chrome Theme
To use the Chrome theme, open the `chrome` folder on `/usr/share/themes/Flat-Plat<-variant>` and drag and drop the `.crx` files onto the Chrome/Chromium _Extensions_ page.

GDM Theme
---------
You can change the GDM (lock/login screen) theme by replacing the default GNOME Shell theme.  
However, if it fails, the desktop environment may not operate correctly. So please **be careful** if doing this.

#### :warning: Cautions:
- When applying this, other third-party GNOME Shell themes would look broken until you restore to the original theme.
- If GNOME Shell has been updated, it will be restored to the original theme, so you will need to install this again.

### Installation
1. Select a **GTK+** theme to decide which variant to install.
2. Run the following commands to back up and replace the default theme file.

  ```sh
  GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
  sudo cp -v --backup /usr/share{/themes/$GTK_THEME,}/gnome-shell/gnome-shell-theme.gresource
  ```

  > **Note:** If you don't want to overwrite the backup on the second and subsequent runs, delete the `--backup` option.

3. Restart GNOME Shell. (If you are running _GNOME on Xorg_, press <kbd>Alt</kbd> + <kbd>F2</kbd> then type `r`.)

### Uninstallation
1. Restore to the original theme from the backup.

  ```sh
  sudo mv -v /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
  ```

2. Restart GNOME Shell. (If you are running _GNOME on Xorg_, press <kbd>Alt</kbd> + <kbd>F2</kbd> then type `r`.)

Preview
-------
##### GNOME Shell
![GNOME Shell](../images/gnome.png?raw=true)
##### Budgie Desktop
![Budgie Desktop](../images/budgie.png?raw=true)
##### GDM
![GDM](../images/gdm-unlock.png?raw=true)
<sub>**Preview Details:** Icons: [Paper](https://github.com/snwh/paper-icon-theme) | Font: [M+ 1C](https://mplus-fonts.osdn.jp) 9.75pt | Dock's icon size: 48px + fixed | [Wallpapers](https://imgur.com/a/v2Ovx)</sub>

Planned Features
----------------
- Supports of Xfce theme (waiting for the upstream to complete `gtk3` port)
- Supports of Firefox theme ([in progress](https://github.com/nana-4/Flat-Plat/issues/78), waiting for [the upstream to provide next-gen themes](https://blog.mozilla.org/addons/2017/02/24/improving-themes-in-firefox/))
- Supports of overlay scrollbars for Chrome/Chromium extension (low priority)
- GNOME Terminal color palette (if possible, _help wanted_)
- Material Design like cursor theme (low priority)

Contributing
------------
If you find bugs or have suggestions, please report it to the [issue tracker](https://github.com/nana-4/Flat-Plat/issues).  
Any contribution will be much appreciated.

License
-------
Flat-Plat is distributed under the terms of the GNU General Public License, version 2 or later. See the [`COPYING`](COPYING) file for details.

Credits
-------
- This theme is based on [Adwaita](HACKING.md#useful-links) by GNOME.
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
- The original concept is Google's [Material Design](https://material.io).
- Yauhen Kirylau (@actionless) who is oomox author polished scripts and supported Flat-Plat with [oomox](https://github.com/actionless/oomox).

Also thank you for all contributors and upstream developers.
