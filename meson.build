project(
  'materia-theme',
  version: '20210322',
  license: 'GPLv2+',
  meson_version: '>= 0.47.0',
  default_options: ['prefix=/usr'],
)

theme_base_name = get_option('theme_name')
theme_base_dir = join_paths(get_option('datadir'), 'themes', theme_base_name)

# Avoid printing 'Program sh found' multiple times
# if meson version is >= 0.55.0
if meson.version().version_compare('>= 0.55.0')
  sh = find_program('sh')
else
  sh = 'sh'
endif

sassc = find_program('sassc')
sassc_opts = ['-M', '-t', 'expanded']

themes = []
foreach color: get_option('colors')
  foreach size: get_option('sizes')
    color_suffix = color == 'default' ? '' : '-@0@'.format(color)
    size_suffix = size == 'default' ? '' : '-@0@'.format(size)

    scss_dark_theme = color == 'dark' ? 'true' : 'false'
    scss_light_topbar = color == 'light' ? 'true' : 'false'
    scss_compact = size == 'compact' ? 'true' : 'false'

    themes += {
      'name': theme_base_name + color_suffix + size_suffix,
      'dir': theme_base_dir + color_suffix + size_suffix,
      'color': color_suffix,
      'size': size_suffix,
      'scss_dark_theme': scss_dark_theme,
      'scss_light_topbar': scss_light_topbar,
      'scss_compact': scss_compact,
    }
  endforeach
endforeach

foreach theme: themes
  install_data(
    [
      'COPYING',
      'INSTALL_GDM_THEME.md',
    ],
    install_dir: theme['dir'],
  )
endforeach

if not get_option('flatpak')
  subdir('src')
else
  subdir('src/gtk-3.0')
  subdir('src/gtk-4.0')
endif
