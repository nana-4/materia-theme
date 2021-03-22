<img src="images/materia-logo.svg" alt="materia-logo" align="right" />

# Materia

Materia is a [Material Design](https://material.io) theme for GNOME/GTK based desktop environments.

It supports GTK 2, GTK 3, GTK 4, GNOME Shell, Budgie, Cinnamon, MATE, Unity, Xfce, LightDM, GDM, Chrome theme, etc.

## Previews

![widget-factory](images/widget-factory.png?raw=true)
![widget-factory-dark](images/widget-factory-dark.png?raw=true)

## Features

Supports **ripple animations** for GTK 3 and 4:

![ripple](images/ripple.gif?raw=true)

**3 color variants** and **2 size variants** are available:

**Materia** | **standard** | **compact**
:-: | :-: | :-:
**standard** | ![Materia][1] | ![Materia-compact][2]
**dark** | ![Materia-dark][3] | ![Materia-dark-compact][4]
**light** | ![Materia-light][5] | ![Materia-light-compact][6]

[1]: images/Materia.png?raw=true
[2]: images/Materia-compact.png?raw=true
[3]: images/Materia-dark.png?raw=true
[4]: images/Materia-dark-compact.png?raw=true
[5]: images/Materia-light.png?raw=true
[6]: images/Materia-light-compact.png?raw=true

## Supported Toolkits and Desktops

- GTK 2
- GTK 3 `>=3.20`
- GTK 4 `>=4.0`
- Budgie `>=10.4`
- Cinnamon `>=3.x`
- GNOME Shell `>=3.26`
- MATE `>=1.14`
- Unity `>=7.4`
- Xfce `>=4.13`

## Unsupported Apps and Desktops

- elementary apps
  > Because they are based on [their own stylesheet](https://github.com/elementary/stylesheet) that conflicts with GTK standards.
- Downstream customized GNOME sessions
  > E.g. "Ubuntu" session, "Pop" session. To properly use Materia on GNOME Shell, please install `gnome-session` and then switch to "GNOME" or "GNOME on Xorg" session from your display manager.

## Installation

### Distro Packages

<!-- For contributors, please add your package alphabetically. -->

Distro | Package Name | Annotation
--- | --- | ---
Arch Linux | `materia-gtk-theme` | [Link](https://www.archlinux.org/packages/community/any/materia-gtk-theme/)
Debian 10 or later | `materia-gtk-theme` | [Link](https://packages.debian.org/materia-gtk-theme)
Fedora | `materia-gtk-theme` | [Link](https://src.fedoraproject.org/rpms/materia-gtk-theme)
Solus | `materia-gtk-theme` | [Link](https://dev.getsol.us/source/materia-gtk-theme/)
Ubuntu 18.04 or later | `materia-gtk-theme` | [Link](https://packages.ubuntu.com/materia-gtk-theme)

> NOTE: Distro packages could be outdated and incompatible with your desktop environment. You can check the latest version [here](https://github.com/nana-4/materia-theme/releases).

### Flatpak

All 6 variants are available via Flathub:

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.gtk.Gtk3theme.Materia{,-dark,-light}{,-compact}
```

### Manual Installation

See [`INSTALL.md`](INSTALL.md) for details.

## Recommendations

### Font

- Use a font family including **Medium** weight (e.g. [Roboto](https://github.com/google/roboto) or [M+](https://mplus-fonts.osdn.jp)) to properly display the theme.
- Set the font size to `9.75` (= 13px at 96dpi) or `10.5` (= 14px at 96dpi).

### Chrome Extensions

To improve the appearance of Chrome, you can install our Chrome extensions as follows:

1. Open the `/usr/share/themes/Materia<-variant>/chrome` folder in your file manager.
2. Drag and drop the `.crx` files into the Chrome's Extensions page (`chrome://extensions`).

### GDM Theme

You can change the GDM (lock/login screen) theme by replacing the default GNOME Shell theme.  
See [`INSTALL_GDM_THEME.md`](INSTALL_GDM_THEME.md) for details.

## Customization

Materia can be customized with GUI application, [**oomox theme designer**](https://github.com/themix-project/oomox).

Materia also allows you to change the color scheme relatively easily in other ways. See [`HACKING.md`](HACKING.md#how-to-change-the-color-scheme) for details.

## Contributing

If you find bugs or have suggestions, please report it to the [issue tracker](https://github.com/nana-4/materia-theme/issues). Any contribution would be much appreciated.

Todo list can be found at [`TODO.md`](TODO.md).

## Related Projects

- [**Materia KDE**](https://github.com/PapirusDevelopmentTeam/materia-kde) by @PapirusDevelopmentTeam
- [**Materia VSCode Theme**](https://marketplace.visualstudio.com/items?itemName=m-thorsen.vscode-materia) by @m-thorsen
- [**Materia Kolorizer**](https://github.com/DarthWound/materia-kolorizer) by @DarthWound
- [**oomox theme designer**](https://github.com/themix-project/oomox) by @themix-project

## License

Materia is distributed under the terms of the GNU General Public License, version 2 or later. See the [`COPYING`](COPYING) file for details.

## Acknowledgments

- Materia is based on [Adwaita](HACKING.md#upstream-theme-sources) by GNOME.
- Design and specifications are based on Google's [Material Design](https://material.io).
- The included symbolic icons are based on [Material Design icons](https://github.com/google/material-design-icons) by Google.
- The Chrome scrollbar extension was forked from [Adwaita-chrome-scrollbar](https://github.com/gnome-integration-team/chrome-gnome-scrollbar) by GNOME Integration Team.
- Yauhen Kirylau (@actionless) who is oomox author polished scripts and supported Materia with [oomox](https://github.com/themix-project/oomox).
- @n3oxmind who helped improve the installation script.
- @smurphos who made and provided the Cinnamon theme for Materia.
- Our Meson code is heavily influenced by @monday15's [lounge-gtk-theme](https://github.com/monday15/lounge-gtk-theme).

Also thank you to all contributors and upstream developers.
