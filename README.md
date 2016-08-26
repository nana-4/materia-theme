Flat-Plat
=========
A Material Design-like theme for GNOME/GTK+ based desktop environments.

Features
--------
<img src="img/Button.gif" alt="Button" align="right" />
* Supports ripple effect animations (only GTK3 apps).
* Supports both light and dark variants.
* Supports [Dash to Dock](https://github.com/micheleg/dash-to-dock) extension's theming.
* Supports [Workspaces to Dock](https://github.com/passingthru67/workspaces-to-dock) extension's theming.
* Supports Chrome/Chromium theme and scrollbars extensions.
* Appears more beautifully when you use a font family including `Medium` and `Light` weights.

Requirements
------------
* GTK+ 3.14, 3.16, 3.18 or 3.20
* `gnome-themes-standard`
* pixmap (or pixbuf) engine
* murrine engine

##### Supported desktop environments are:
* GNOME Shell 3.14, 3.16, 3.18 or 3.20
* Unity 7.4 (Ubuntu 16.04)

Installation
------------
1. Download an archive.
  * [v3.20.20160821](https://github.com/nana-4/Flat-Plat/releases/download/v3.20.20160821/Flat-Plat-3.20.20160821.tar.gz) for GNOME 3.20
  * [v3.20.20160821](https://github.com/nana-4/Flat-Plat/releases/download/v3.20.20160821/Flat-Plat-laptop-3.20.20160821.tar.gz) for GNOME 3.20 and small resolution
  * [v3.18.20160821](https://github.com/nana-4/Flat-Plat/releases/download/v3.18.20160821/Flat-Plat-3.18.20160821.tar.gz) for GNOME 3.18 or Unity 7.4 (Ubuntu 16.04)
  * [v3.16.20160821](https://github.com/nana-4/Flat-Plat/releases/download/v3.16.20160821/Flat-Plat-3.16.20160821.tar.gz) for GNOME 3.16
  * [v3.14.20160821](https://github.com/nana-4/Flat-Plat/releases/download/v3.14.20160821/Flat-Plat-3.14.20160821.tar.gz) for GNOME 3.14
2. Extract it to the theme directory.
  * For system-wide installation to `/usr/share/themes`
  * For user-specific installation to `~/.themes`
3. Select the theme via `gnome-tweak-tool` or `unity-tweak-tool`.
4. [Optional] Set the font size to 10.5 (=14px) or 9.75 (=13px).
5. [Optional] Open the `chrome` folder and drag and drop the `.crx` files onto the Chrome/Chromium extensions page (`chrome://extensions/`).

#### Note if you want to clone from the repository
The `master` branch is currently being built for GNOME 3.20.  
If you want to use [other versions](https://github.com/nana-4/Flat-Plat/branches/all), you need to specify the branch as follows:

    git clone -b 3.18 https://github.com/nana-4/Flat-Plat.git

GDM (Lock/Login Screen)
-----------------------
You can change the GDM theme by rewriting a system file.  
But please **be careful** because if it fails, the desktop environment may not operate correctly.
> **Notes:**
> * When applying this, other GNOME Shell themes might look broken.
> * If GNOME Shell has been updated, you will need to install again.
> * Not supported for GNOME 3.14.

### Install
1. Backup the existing `.gresource` file. _(Skip this step if you just update it.)_

        sudo cp -i /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource~
2. Replace it with the new one.

        cd /usr/share/themes/Flat-Plat || cd ~/.themes/Flat-Plat
        sudo cp -div gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell
3. Restart GNOME Shell (press `Alt`+`F2`, then type `r`).

### Uninstall
1. Restore to original theme from the backup.

        sudo mv -iv /usr/share/gnome-shell/gnome-shell-theme.gresource~ /usr/share/gnome-shell/gnome-shell-theme.gresource
2. Restart GNOME Shell (press `Alt`+`F2`, then type `r`).

Screenshots
-----------
##### GNOME Shell 3.20
![GNOME Shell 3.20](img/Screenshot1.png?raw=true)
##### Unity 7.4
![Unity 7.4](img/Screenshot2.png?raw=true)
##### GDM Lock Screen
![GDM Lock Screen](img/Screenshot3.png?raw=true)
##### GDM Unlock Screen
![GDM Unlock Screen](img/Screenshot4.png?raw=true)
<sub>**Screenshots Details:** Icons: [Paper](https://github.com/snwh/paper-icon-theme) | Font: [M+ 1C](https://mplus-fonts.osdn.jp/) 10.5pt | Dock's icon size: 48px + fixed | [Wallpapers](http://imgur.com/a/v2Ovx)</sub>

Bug Reporting
-------------
If you find a bug, please report it here: https://github.com/nana-4/Flat-Plat/issues

Planned Features
----------------
* Supports of global dark theme
* Supports of Xfce theme
* Supports of Firefox theme
* Supports of overlay scrollbars for Chrome/Chromium extension
* GNOME Terminal color pallet (if possible)
* Material Design like cursor theme

License
-------
Flat-Plat is available under the terms of the GPL. See the `COPYING` file for details.
> **Notes:**
> * Included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
> * Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
