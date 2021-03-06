project(
  'materia-theme',
  version: '20200916',
  license: 'GPLv2+',
  meson_version: '>= 0.47.0',
  default_options: ['prefix=/usr'],
)

theme_base_name = get_option('theme_name')
theme_base_dir = join_paths(get_option('datadir'), 'themes', theme_base_name)

sassc = find_program('sassc')
sassc_opts = ['-M', '-t', 'expanded']

themes = []
foreach color: get_option('colors')
  foreach size: get_option('sizes')
    if color == 'default'
      color_suffix = ''
      scss_dark_theme = 'false'
      scss_light_topbar = 'false'
    elif color == 'light'
      color_suffix = '-light'
      scss_dark_theme = 'false'
      scss_light_topbar = 'true'
    elif color == 'dark'
      color_suffix = '-dark'
      scss_dark_theme = 'true'
      scss_light_topbar = 'false'
    endif

    if size == 'default'
      size_suffix = ''
      scss_compact = 'false'
    elif size == 'compact'
      size_suffix = '-compact'
      scss_compact = 'true'
    endif

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
    'COPYING',
    install_dir: theme['dir'],
  )
endforeach

if not get_option('flatpak')
  subdir('src')
else
  subdir('src/gtk')
endif
