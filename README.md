Flat-Plat
=========
Flat-Plat is a [Material Design](https://material.io)-like theme for GNOME/GTK+ based desktop environments.  
It supports GTK3, GTK2, Metacity, GNOME Shell, Unity, MATE, LightDM and GDM.

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
Arch Linux users can install from the [AUR package](https://aur.archlinux.org/packages/flatplat-theme) maintained by [@cthbleachbit](https://github.com/cthbleachbit).

### Manual Installation
1. Download and extract the [stable archive](../../releases).

  ```sh
  cd /tmp
  curl -sL https://github.com/nana-4/Flat-Plat/archive/v20161227.tar.gz | tar xz
  ```

2. In terminal, move to the extracted directory and run `./install.sh` as root.

  ```sh
  cd Flat-Plat-20161227 && sudo ./install.sh
  ```

3. Select the theme via `gnome-tweak-tool` or other suitable tools.

4. Optionally, configure the following settings:
  - Set the system font size to `9.75` (= 13px at 96dpi) or `10.5` (= 14px at 96dpi).
  - Open the `chrome` folder on `/usr/share/themes/Flat-Plat*/` and drag and drop the `.crx` files onto the Chrome/Chromium extensions page (`chrome://extensions`).

---

**Note:** Series 3.14 and 3.16 are no longer supported. If you want to get the final version, you can download from the link below.
- [:arrow_down: v3.14.20160921](../../releases/download/v3.14.20160921/Flat-Plat-3.14.20160921.tar.gz)
- [:arrow_down: v3.16.20160821](../../releases/download/v3.16.20160821/Flat-Plat-3.16.20160821.tar.gz)

---

### Manual Uninstallation
- Delete the installed directories.

  ```sh
  sudo rm -rf /usr/share/themes/Flat-Plat{,-compact,-dark,-dark-compact,-light,-light-compact}
  ```

GDM (Lock/Login Screen)
-----------------------
You can change the GDM theme by replacing the default GNOME Shell theme.  
But please **be careful** because if it fails, the desktop environment may not operate correctly.
> **:warning: Cautions:**
> - When applying this, other third-party GNOME Shell themes would look broken.
> - If GNOME Shell has been updated, you will need to install this again.

### Installation
1. Back up and replace the existing `.gresource` file after selecting the GTK+ theme.

  ```sh
  GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
  sudo cp -iv --backup /usr/share{/themes/$GTK_THEME,}/gnome-shell/gnome-shell-theme.gresource
  ```

  > _Developer note:_  
  > If you don't want to overwrite the backup on the second and subsequent runs, delete the `--backup` option.

2. Restart GNOME Shell (press <kbd>Alt</kbd> + <kbd>F2</kbd>, then type `r`).

### Uninstallation
1. Restore to original theme from the backup.

  ```sh
  sudo mv -iv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
  ```

2. Restart GNOME Shell (press <kbd>Alt</kbd> + <kbd>F2</kbd>, then type `r`).

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
If you find any bugs or mistakes, please report it to [GitHub's issue tracker](https://github.com/nana-4/Flat-Plat/issues) or send a pull request.  
Thank you in advance for your cooperation. :+1:

Planned Features
----------------
- Supports of global dark theme
- Supports of Xfce theme
- Supports of Firefox theme ([in progress](https://github.com/nana-4/Flat-Plat/issues/78))
- Supports of overlay scrollbars for Chrome/Chromium extension
- GNOME Terminal color pallet (if possible)
- Material Design like cursor theme

License
-------
Flat-Plat is available under the terms of the GPL. See the [`COPYING`](COPYING) file for details.

Acknowledgments
---------------
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
