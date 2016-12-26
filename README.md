Flat-Plat
=========
Flat-Plat is a [Material Design](https://material.io)-like theme for GNOME/GTK+ based desktop environments.  
It supports GTK3, GTK2, Metacity, GNOME Shell, Unity, MATE, LightDM and GDM.

Features
--------
<img src="../images/Button.gif" alt="Button" align="right"/>
* Supports ripple effect animations (only GTK3 apps).
* Supports both light and dark variants.
* Supports dark or light titlebar versions.
* Supports compact version for low resolution.
* Supports [Dash to Dock](https://github.com/micheleg/dash-to-dock) extension's theming.
* Supports [Workspaces to Dock](https://github.com/passingthru67/workspaces-to-dock) extension's theming.
* Supports Chrome/Chromium theme and scrollbars extension.
* Appears more beautifully when you use a font family including `Medium` and `Light` weights.

Requirements
------------
* GTK+ 3.14 or later
* `gnome-themes-standard`
* pixmap (or pixbuf) engine
* murrine engine

##### Supported desktop environments are:
* GNOME Shell 3.14 or later
* Unity 7.4 or later
* MATE 1.14 or later

Installation
------------
Arch Linux users can install from [the AUR package](https://aur.archlinux.org/packages/flatplat-theme) maintained by [@cthbleachbit](https://github.com/cthbleachbit).

### Manual Installation
1. Download an archive from the table.

  |   | :black_circle:Dark titlebar | :black_circle:Dark titlebar (compact) | :white_circle:Light titlebar | :white_circle:Light titlebar (compact) |
  |:--|:-:|:-:|:-:|:-:|
  | GNOME 3.22 | [:arrow_down:v3.22.20161109](../../releases/download/v3.22.20161109/Flat-Plat-3.22.20161109.tar.gz) | [:arrow_down:v3.22.20161109](../../releases/download/v3.22.20161109/Flat-Plat-laptop-3.22.20161109.tar.gz) | [:arrow_down:v3.22.20161109](../../releases/download/v3.22.20161109/Flat-Plat-light-3.22.20161109.tar.gz) | [:arrow_down:v3.22.20161109](../../releases/download/v3.22.20161109/Flat-Plat-light-laptop-3.22.20161109.tar.gz) |
  | GNOME 3.20 | [:arrow_down:v3.20.20161109](../../releases/download/v3.20.20161109/Flat-Plat-3.20.20161109.tar.gz) | [:arrow_down:v3.20.20161109](../../releases/download/v3.20.20161109/Flat-Plat-laptop-3.20.20161109.tar.gz) | [:arrow_down:v3.20.20161109](../../releases/download/v3.20.20161109/Flat-Plat-light-3.20.20161109.tar.gz) | [:arrow_down:v3.20.20161109](../../releases/download/v3.20.20161109/Flat-Plat-light-laptop-3.20.20161109.tar.gz) |
  | GNOME 3.18 | [:arrow_down:v3.18.20161109](../../releases/download/v3.18.20161109/Flat-Plat-3.18.20161109.tar.gz) | n/a | [:arrow_down:v3.18.20161109](../../releases/download/v3.18.20161109/Flat-Plat-light-3.18.20161109.tar.gz) | n/a |
  | GNOME 3.16 | n/a | n/a | [:arrow_down:v3.16.20160821](../../releases/download/v3.16.20160821/Flat-Plat-3.16.20160821.tar.gz) | n/a |
  | GNOME 3.14 | n/a | n/a | [:arrow_down:v3.14.20160921](../../releases/download/v3.14.20160921/Flat-Plat-3.14.20160921.tar.gz) | n/a |
  > **:beginner: Tips:**
  > * Choose from _GNOME 3.22_ if you are using MATE 1.16.
  > * Choose from _GNOME 3.20_ if you are using Unity 7.5 (Ubuntu 16.10) or MATE 1.14.
  > * Choose from _GNOME 3.18_ if you are using Unity 7.4 (Ubuntu 16.04).
2. Extract it to the theme directory.
  * for system-wide installation to `/usr/share/themes`
  * for user-specific installation to `~/.themes`
3. Select the theme via `gnome-tweak-tool` or other suitable tools.
4. Optionally, do the following works.
  * Set the font size to `10.5` (= 14px at 96dpi) or `9.75` (= 13px at 96dpi).
  * Open the `chrome` folder and drag and drop the `.crx` files onto the Chrome/Chromium extensions page (`chrome://extensions`).

#### Note if you want to clone from the repository
The `master` branch is currently being built for GNOME 3.22.  
If you want to use [other versions](../../branches/all), you need to specify the branch as follows:

```
git clone -b 3.18 https://github.com/nana-4/Flat-Plat.git
```

GDM (Lock/Login Screen)
-----------------------
You can change the GDM theme by replacing the default GNOME Shell theme.  
But please **be careful** because if it fails, the desktop environment may not operate correctly.
> **:warning: Warning:**
> * When applying this, other third-party GNOME Shell themes would look broken.
> * If GNOME Shell has been updated, you will need to install this again.
> * Not supported for GNOME 3.14.

### Installation
1. Backup the existing `.gresource` file. _(Skip this step if you just update it.)_

  ```
  sudo cp -iv /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
  ```

2. Replace it with the new one.

  ```
  cd /usr/share/themes/Flat-Plat || cd ~/.themes/Flat-Plat
  sudo cp -iv {.,/usr/share}/gnome-shell/gnome-shell-theme.gresource
  ```

3. Restart GNOME Shell (press <kbd>Alt</kbd> + <kbd>F2</kbd>, then type `r`).

### Uninstallation
1. Restore to original theme from the backup.

  ```
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
* Supports of global dark theme
* Supports of Xfce theme
* Supports of Firefox theme ([in progress](https://github.com/nana-4/Flat-Plat/issues/78))
* Supports of overlay scrollbars for Chrome/Chromium extension
* GNOME Terminal color pallet (if possible)
* Material Design like cursor theme

License
-------
Flat-Plat is available under the terms of the GPL. See the [`COPYING`](COPYING) file for details.

Acknowledgments
---------------
* The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
* Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
