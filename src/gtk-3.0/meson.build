gtk3_scss_depend_files = files([
  '../_color-palette.scss',
  '../_colors.scss',
  '../_variables.scss',
  'sass/apps/_budgie.scss',
  'sass/apps/_gnome.scss',
  'sass/apps/_libhandy.scss',
  'sass/apps/_lightdm.scss',
  'sass/apps/_mate.scss',
  'sass/apps/_misc.scss',
  'sass/apps/_nemo.scss',
  'sass/apps/_unity.scss',
  'sass/apps/_xfce.scss',
  'sass/_apps.scss',
  'sass/_colors-public.scss',
  'sass/_common.scss',
  'sass/_drawing.scss',
])

foreach theme: themes
  gtk3_dir = join_paths(theme['dir'], 'gtk-3.0')

  gtk3_variants = [
    'gtk',
  ]

  # Only non-dark themes need a dark variant.
  if theme['color'] != '-dark'
    gtk3_variants += 'gtk-dark'
  endif

  install_subdir(
    'assets',
    install_dir: gtk3_dir,
  )

  install_subdir(
    'icons',
    install_dir: gtk3_dir,
  )

  #
  # SCSS
  #

  gtk3_scss_conf = configuration_data()
  gtk3_scss_conf.set('dark_theme', theme['scss_dark_theme'])
  gtk3_scss_conf.set('light_topbar', theme['scss_light_topbar'])
  gtk3_scss_conf.set('compact', theme['scss_compact'])
  gtk3_scss_conf.set('current_source_dir', meson.current_source_dir())

  foreach gtk3_variant: gtk3_variants
    gtk3_temp_name = '@0@.gtk3.@1@'.format(theme['name'], gtk3_variant)

    # Configure SCSS file
    gtk3_scss = configure_file(
      input: '@0@.scss.in'.format(gtk3_variant),
      output: '@0@.scss'.format(gtk3_temp_name),
      configuration: gtk3_scss_conf,
    )

    # Generate CSS file
    gtk3_css = custom_target(
      '@0@.css'.format(gtk3_temp_name),
      input: gtk3_scss,
      output: '@0@.css'.format(gtk3_temp_name),
      command: [sass, sass_opts, '@INPUT@', '@OUTPUT@'],
      depend_files: gtk3_scss_depend_files,
      build_by_default: true,
    )

    # Install it while renaming to a valid name
    meson.add_install_script(
      sh, '-c', 'cp "@0@" "@1@"'.format(
        gtk3_css.full_path(),
        join_paths('$MESON_INSTALL_DESTDIR_PREFIX', gtk3_dir, '@0@.css'.format(gtk3_variant)),
      ),
    )
  endforeach
endforeach
