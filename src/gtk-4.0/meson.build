gtk4_launch = find_program('gtk4-launch', required: false)

if get_option('gtk4_version') != ''
  gtk4_full_version = get_option('gtk4_version')
elif gtk4_launch.found()
  gtk4_full_version = run_command(gtk4_launch, '--version').stdout()
else
  message('gtk4-launch not found, using styles for last gtk4 version availible')
  gtk4_full_version = '4.0'
endif

gtk4_version_array = gtk4_full_version.split('.')
if gtk4_version_array[1].to_int().is_even()
  gtk4_version = gtk4_version_array[0] + '.' + gtk4_version_array[1]
else
  gtk4_version = gtk4_version_array[0] + '.' + (gtk4_version_array[1].to_int() + 1).to_string()
endif
message('Set gtk4 version to ' + gtk4_version)

gtk4_scss_depend_files = files([
  '../_color-palette.scss',
  '../_shadow.scss',
  '../_theme.scss',
  '../_theme-color.scss',
  '../gtk-3.0/sass/_public-colors.scss',
  'sass/_common.scss',
  'sass/_drawing.scss',
  'sass/_gtk.scss',
])

foreach theme: themes
  gtk4_dir = join_paths(theme['dir'], 'gtk-4.0')

  gtk4_variants = [
    'gtk',
  ]

  # Only non-dark themes need a dark variant.
  if theme['color'] != '-dark'
    gtk4_variants += 'gtk-dark'
  endif

  install_subdir(
    '../gtk-3.0/assets',
    install_dir: gtk4_dir,
  )

  install_subdir(
    '../gtk-3.0/icons',
    install_dir: gtk4_dir,
  )

  #
  # SCSS
  #

  gtk4_scss_conf = configuration_data()
  gtk4_scss_conf.set('dark_theme', theme['scss_dark_theme'])
  gtk4_scss_conf.set('light_topbar', theme['scss_light_topbar'])
  gtk4_scss_conf.set('compact', theme['scss_compact'])
  gtk4_scss_conf.set('version', gtk4_version)
  gtk4_scss_conf.set('current_source_dir', meson.current_source_dir())

  foreach gtk4_variant: gtk4_variants
    gtk4_temp_name = '@0@.gtk4.@1@'.format(theme['name'], gtk4_variant)

    # Configure SCSS file
    gtk4_scss = configure_file(
      input: '@0@.scss.in'.format(gtk4_variant),
      output: '@0@.scss'.format(gtk4_temp_name),
      configuration: gtk4_scss_conf,
    )

    # Generate CSS file
    gtk4_css = custom_target(
      '@0@.css'.format(gtk4_temp_name),
      input: gtk4_scss,
      output: '@0@.css'.format(gtk4_temp_name),
      command: [sass, sass_opts, '@INPUT@', '@OUTPUT@'],
      depend_files: gtk4_scss_depend_files,
      build_by_default: true,
    )

    # Install it while renaming to a valid name
    meson.add_install_script(
      sh, '-c', 'cp "@0@" "@1@"'.format(
        gtk4_css.full_path(),
        join_paths('$MESON_INSTALL_DESTDIR_PREFIX', gtk4_dir, '@0@.css'.format(gtk4_variant)),
      ),
    )
  endforeach
endforeach
