## Installation from source

### Dependencies

Materia requires the following build and runtime dependencies:

#### Build dependencies

- `meson` >= 0.47.0
- `dart-sass` >= 1.23.0 (or `npm` if the former is not found)

#### Runtime dependencies

- `gnome-themes-extra` (or `gnome-themes-standard` for older distributions)
- Murrine engine — The package name depends on the distro:
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.

### Steps to install

1. Clone the repository and move into the project directory in terminal:

```sh
git clone https://github.com/nana-4/materia-theme
cd materia-theme
```

2. Configure the project using Meson (you can specify build options [as below](#build-options)):

```sh
meson _build
```

3. Build and install it using Meson:

```sh
meson install -C _build
```

### Build options

Option | Default Value | Description
--- | --- | ---
`prefix` | `/usr` | Installation prefix
`colors` | `default,light,dark` | Choose color variant(s)
`sizes` | `default,compact` | Choose size variant(s)
`gnome_shell_version` | n/a (auto) | Manually set gnome-shell version
`gtk4_version` | n/a (auto) | Manually set gtk4 version

Build options can be set at the configuration time, for example:

```sh
meson _build -Dprefix="$HOME/.local" -Dcolors=default,dark -Dsizes=compact
```

## Uninstallation

Delete the installed directories:

```sh
sudo rm -rf /usr/share/themes/Materia{,-dark,-light}{,-compact}
```
