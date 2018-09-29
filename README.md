# Materia

![widget-factory](../images/widget-factory.png?raw=true)

Materia (formerly Flat-Plat) is a [Material Design](https://material.io) theme for GNOME/GTK+ based desktop environments.  
It supports GTK+ 3, GTK+ 2, GNOME Shell, Budgie, Cinnamon, MATE, Unity, LightDM, GDM, Chrome theme, etc.

Also Materia has compatibility with [oomox theme designer](https://github.com/themix-project/oomox).

## Features

**Ripple effect** animations for GTK+ 3 are supported:

![Button](../images/Button.gif?raw=true)

**3 color variants** and **2 size variants** are available:

| **Materia** | **standard** | **compact** |
| :-: | :-: | :-: |
| **standard** | ![Materia][1] | ![Materia-compact][2] |
| **dark** | ![Materia-dark][3] | ![Materia-dark-compact][4] |
| **light** | ![Materia-light][5] | ![Materia-light-compact][6] |

[1]: ../images/Materia.png?raw=true
[2]: ../images/Materia-compact.png?raw=true
[3]: ../images/Materia-dark.png?raw=true
[4]: ../images/Materia-dark-compact.png?raw=true
[5]: ../images/Materia-light.png?raw=true
[6]: ../images/Materia-light-compact.png?raw=true

Various **desktop environments** are supported:

- GNOME Shell `>=3.18`
- Budgie `>=10.2.5`
- Cinnamon `>=3.x`
- MATE `>=1.14`
- Unity `>=7.4`

## Requirements

- GTK+ `>=3.20`
- `gnome-themes-extra` (or `gnome-themes-standard`)
- Murrine engine — The package name depends on the distro.
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.
- `bc` — build dependency

## Installation

### Packages

| Distro | Maintainer | Install Command |
| :-- | :-- | :-- |
| Arch Linux <sup>[[Official][Arch]]</sup> | @ArchangeGabriel | `sudo pacman -S materia-gtk-theme` |
| Debian 10 / sid <sup>[[Official][Debian]]</sup> <br> Ubuntu 18.04+ | @isaagar | `sudo apt install materia-gtk-theme` |
| Ubuntu 16.04 / 17.10 <sup>[[PPA][PPA]]</sup> | @igor-dyatlov | `sudo add-apt-repository ppa:dyatlov-igor/materia-theme` <br> `sudo apt update` <br> `sudo apt install materia-gtk-theme` |
| Fedora <sup>[[Copr][Copr]]</sup> | @LaurentTreguier | `sudo dnf copr enable tcg/themes` <br> `sudo dnf install materia-theme` |

[Arch]: https://www.archlinux.org/packages/community/any/materia-gtk-theme
[Debian]: https://packages.debian.org/unstable/materia-gtk-theme
[PPA]: https://launchpad.net/~dyatlov-igor/+archive/ubuntu/materia-theme
[Copr]: https://copr.fedorainfracloud.org/coprs/tcg/themes

#### Flatpak

3 variants (Materia, Materia-dark, Materia-light) are available via Flathub:

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.gtk.Gtk3theme.Materia
flatpak install flathub org.gtk.Gtk3theme.Materia-dark
flatpak install flathub org.gtk.Gtk3theme.Materia-light
```

### Manual Installation

Run the following commands in the terminal:

```sh
cd /tmp && wget -qO - https://github.com/nana-4/materia-theme/archive/master.tar.gz | tar xz
cd materia-theme-master
sudo ./install.sh
```

Note: `./install.sh` allows the following options:

```
-d, --dest DIR           Specify destination directory
-n, --name NAME          Specify theme name
-c, --color VARIANTS...  Specify color variant(s) [standard|dark|light]
-s, --size VARIANT       Specify size variant [standard|compact]
```

Without any options, Materia will be installed with all variants into `/usr/share/themes`.  
Try `./install.sh --help` for more information.

### Manual Uninstallation

Delete the installed directories:

```sh
sudo rm -rf /usr/share/themes/Materia{,-compact,-dark,-dark-compact,-light,-light-compact}
```

## Recommendations

#### Font

- To properly display the theme, use a font family including **Medium** weight (e.g. [Roboto](https://github.com/google/roboto) or [M+](https://mplus-fonts.osdn.jp)).
- Set the font size to `9.75` or `10.5` (i.e. 13px or 14px at 96dpi).

#### Chrome Theme

To use the Chrome theme;

1. Open the `chrome` folder on `/usr/share/themes/Materia<-variant>`.
2. Drag and drop the `.crx` files into the Chrome/Chromium Extensions page (`chrome://extensions`).

#### GDM Theme

You can change the GDM (lock/login screen) theme by replacing the default GNOME Shell theme.  
See the wiki for details: https://github.com/nana-4/materia-theme/wiki/GDM-Theme

## Customization

Materia allows you to change the color scheme relatively easily. See [`HACKING.md`](HACKING.md#how-to-change-the-color-scheme) for details.

## Contributing

If you find bugs or have suggestions, please report it to the [issue tracker](https://github.com/nana-4/materia-theme/issues). Any contribution would be much appreciated.

ToDo list can be found here: [`TODO.md`](TODO.md)

## Related Projects

- [**Materia KDE**](https://github.com/PapirusDevelopmentTeam/materia-kde) by @PapirusDevelopmentTeam
- [**Materia VSCode Theme**](https://marketplace.visualstudio.com/items?itemName=m-thorsen.vscode-material-mt) by @m-thorsen
- [**Materia Kolorizer**](https://github.com/DarthWound/materia-kolorizer) by @DarthWound

## License

Materia is distributed under the terms of the GNU General Public License, version 2 or later. See the [`COPYING`](COPYING) file for details.

## Credits

- Materia is based on [Adwaita](HACKING.md#upstream-theme-sources) by GNOME.
- Design and specifications are based on Google's [Material Design](https://material.io).
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- Chrome/Chromium scrollbars extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
- Yauhen Kirylau (@actionless) who is oomox author polished scripts and supported Materia with [oomox](https://github.com/themix-project/oomox).
- @n3oxmind who helped improve the installation script.
- @smurphos who made and provided the Cinnamon theme for Materia.

Also thank you to all contributors and upstream developers.
