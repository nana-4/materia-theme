cinnamon_scss_depend_files = files([
  '../_color-palette.scss',
  '../_shadow.scss',
  '../_theme.scss',
  '../_theme-color.scss',
  '../gnome-shell/sass/_drawing.scss',
  '../gnome-shell/sass/_typography.scss',
  'sass/_common.scss',
  'sass/_extends.scss',
])

foreach theme: themes
  cinnamon_dir = join_paths(theme['dir'], 'cinnamon')

  install_subdir(
    'assets',
    install_dir: cinnamon_dir,
  )

  install_data(
    'thumbnail.png',
    install_dir: cinnamon_dir,
  )

  #
  # SCSS
  #

  cinnamon_scss_conf = configuration_data()
  cinnamon_scss_conf.set('dark_theme', theme['scss_dark_theme'])
  cinnamon_scss_conf.set('light_topbar', theme['scss_light_topbar'])
  cinnamon_scss_conf.set('compact', theme['scss_compact'])
  cinnamon_scss_conf.set('current_source_dir', meson.current_source_dir())

  cinnamon_temp_name = '@0@.cinnamon'.format(theme['name'])

  # Configure SCSS file
  cinnamon_scss = configure_file(
    input: 'cinnamon.scss.in',
    output: '@0@.scss'.format(cinnamon_temp_name),
    configuration: cinnamon_scss_conf,
  )

  # Generate CSS file
  cinnamon_css = custom_target(
    '@0@.css'.format(cinnamon_temp_name),
    input: cinnamon_scss,
    output: '@0@.css'.format(cinnamon_temp_name),
    command: [sass, sass_opts, '@INPUT@', '@OUTPUT@'],
    depend_files: cinnamon_scss_depend_files,
    build_by_default: true,
  )

  # Install it while renaming to a valid name
  meson.add_install_script(
    sh, '-c', 'cp "@0@" "@1@"'.format(
      cinnamon_css.full_path(),
      join_paths('$MESON_INSTALL_DESTDIR_PREFIX', cinnamon_dir, 'cinnamon.css'),
    ),
  )
endforeach
