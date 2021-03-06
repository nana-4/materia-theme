gtk_versions = [
  '3.0',
]

gtk_scss_depend_files = files([
  '../_color-palette.scss',
  '../_colors.scss',
  '../_variables.scss',
  'sass/apps/_budgie.scss',
  'sass/apps/_gnome-3.22.scss',
  'sass/apps/_libhandy.scss',
  'sass/apps/_lightdm.scss',
  'sass/apps/_mate.scss',
  'sass/apps/_misc.scss',
  'sass/apps/_nemo.scss',
  'sass/apps/_unity.scss',
  'sass/apps/_xfce.scss',
  'sass/_apps-3.22.scss',
  'sass/_colors-public.scss',
  'sass/_common-3.20.scss',
  'sass/_drawing-3.20.scss',
])

foreach theme: themes
  gtk_variants = [
    '',
  ]

  # Only non-dark themes need a dark variant.
  if theme['color'] != '-dark'
    gtk_variants += '-dark'
  endif

  gtk_scss_conf = configuration_data()
  gtk_scss_conf.set('dark_theme', theme['scss_dark_theme'])
  gtk_scss_conf.set('light_topbar', theme['scss_light_topbar'])
  gtk_scss_conf.set('compact', theme['scss_compact'])

  foreach gtk_version: gtk_versions
    gtk_version_dir = join_paths(theme['dir'], 'gtk-@0@'.format(gtk_version))

    install_subdir(
      'assets',
      install_dir: gtk_version_dir,
    )

    install_subdir(
      'icons',
      install_dir: gtk_version_dir,
    )

    #
    # SCSS
    #

    foreach gtk_variant: gtk_variants
      gtk_temp_name = 'gtk@0@.gtk-@1@.@2@'.format(gtk_variant, gtk_version, theme['name'])

      # Configure SCSS file
      gtk_scss = configure_file(
        input: 'gtk@0@.scss.in'.format(gtk_variant),
        output: '@0@.scss'.format(gtk_temp_name),
        configuration: gtk_scss_conf,
      )

      # Copy it from build dir to source dir
      run_command(
        'cp',
        gtk_scss,
        meson.current_source_dir(),
      )

      # Generate CSS file
      gtk_css = custom_target(
        '@0@.css'.format(gtk_temp_name),
        input: '@0@.scss'.format(gtk_temp_name),
        output: '@0@.css'.format(gtk_temp_name),
        command: [sassc, sassc_opts, '@INPUT@', '@OUTPUT@'],
        depend_files: gtk_scss_depend_files,
        build_by_default: true,
      )

      # Install it while renaming to a valid name
      meson.add_install_script(
        'sh', '-c', 'cp "@0@" "@1@"'.format(
          gtk_css.full_path(),
          join_paths('$MESON_INSTALL_DESTDIR_PREFIX', gtk_version_dir, 'gtk@0@.css'.format(gtk_variant)),
        ),
      )
    endforeach
  endforeach
endforeach
