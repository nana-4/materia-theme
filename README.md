# Materia

Materia (formerly Flat-Plat) is a [Material Design](https://material.io)-like theme for GNOME/GTK+ based desktop environments.  
It supports GTK+ 3, GTK+ 2, GNOME Shell, Budgie, MATE, Unity, LightDM, GDM, Chrome theme, etc.

Also Materia has compatibility with [oomox theme designer](https://github.com/actionless/oomox).

## Features

**Ripple effect** animations for GTK+ 3 are supported.

![Button](../images/Button.gif?raw=true)

**Three color variants** and **two size variants** are available.

| **Materia** | **-** | **compact** |
|:-:|:-:|:-:|
| **-** | ![Materia](../images/Materia.png?raw=true) | ![Materia-compact](../images/Materia-compact.png?raw=true) |
| **dark** | ![Materia-dark](../images/Materia-dark.png?raw=true) | ![Materia-dark-compact](../images/Materia-dark-compact.png?raw=true) |
| **light** | ![Materia-light](../images/Materia-light.png?raw=true) | ![Materia-light-compact](../images/Materia-light-compact.png?raw=true) |

Various **desktop environments** are supported.

- GNOME Shell `>=3.18`
- Budgie `>=10.2.5`
- MATE `>=1.14`
- Unity `>=7.4`
- ... and more DEs are [planned](TODO.md#supports).

## Installation

#### Packages

|| **Install command** |
|:-|:-|
| **Arch Linux** [1] | `yaourt -S materia-theme` |
| **Fedora / EPEL** [2] | `sudo dnf copr enable tcg/themes && sudo dnf install materia-theme` |

1. The [AUR package](https://aur.archlinux.org/packages/materia-theme/) is maintained by [@cthbleachbit](https://github.com/cthbleachbit).
2. The [Copr repository](https://copr.fedorainfracloud.org/coprs/tcg/themes/) is maintained by [@LaurentTreguier](https://github.com/LaurentTreguier).

#### Manual Installation

Check the dependencies first.

- GTK+ `>=3.18`
- `gnome-themes-standard`
- Murrine engine - The package name depends on the distro.
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.
- `glib-compile-resources` - The package name depends on the distro.
  - `glib2` on Arch Linux
  - `glib2-devel` on Fedora, openSUSE, etc.
  - `libglib2.0-dev` on Debian, Ubuntu, etc.

Install the theme with the following commands.

```sh
cd /tmp && curl -sL https://github.com/nana-4/materia-theme/archive/v20171005.tar.gz | tar xz
cd materia-theme-20171005
sudo ./install.sh
```

#### Manual Uninstallation

Delete the installed directories.

```sh
sudo rm -rf /usr/share/themes/{Materia,Flat-Plat}{,-compact,-dark,-dark-compact,-light,-light-compact}
```

## Recommendations

#### Font

- To properly display the theme, use a font family including `Medium` weight (such as [Roboto](https://github.com/google/roboto) or [M+](https://mplus-fonts.osdn.jp)).
- Set the font size to `9.75` (= 13px at 96dpi) or `10.5` (= 14px at 96dpi).

#### Chrome Theme

To use the Chrome theme,

1. Open the `chrome` folder on `/usr/share/themes/Materia<-variant>`.
2. Drag and drop the `.crx` files onto the Chrome/Chromium Extensions page: `chrome://extensions`

#### GDM Theme

You can change the GDM (lock/login screen) theme by replacing the default GNOME Shell theme.  
See the wiki for details: https://github.com/nana-4/materia-theme/wiki/GDM-Theme

## Previews

##### GNOME Shell
![GNOME Shell](../images/gnome.png?raw=true)

##### Budgie Desktop
![Budgie Desktop](../images/budgie.png?raw=true)

##### GDM
![GDM](../images/gdm-unlock.png?raw=true)

<sub>**Preview Details:** Icons: [Paper](https://github.com/snwh/paper-icon-theme) | Font: [M+ 1C](https://mplus-fonts.osdn.jp) 9.75pt | Dock's icon size: 48px + fixed | [Wallpapers](https://imgur.com/a/v2Ovx)</sub>

## Contributing

If you find bugs or have suggestions, please report it to the [issue tracker](https://github.com/nana-4/materia-theme/issues). Any contribution would be much appreciated.

See also (if necessary): [`TODO.md`](TODO.md) and [`HACKING.md`](HACKING.md)

## License

Materia is distributed under the terms of the GNU General Public License, version 2 or later. See the [`COPYING`](COPYING) file for details.

## Credits

- This theme is based on [Adwaita](HACKING.md#upstream-theme-sources) by GNOME.
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
- The original concept is Google's [Material Design](https://material.io).
- Yauhen Kirylau (@actionless) who is oomox author polished scripts and supported Materia with [oomox](https://github.com/actionless/oomox).

Also thank you to all contributors and upstream developers.
