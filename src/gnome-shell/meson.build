gnome_shell = find_program('gnome-shell', required: false)

if get_option('gnome_shell_version') != ''
  gnome_shell_version = get_option('gnome_shell_version')
else
  if gnome_shell.found()
    gnome_shell_version_array = run_command([gnome_shell, '--version']).stdout().split('\n')[0].split(' ')[-1].strip().split('.')

    if gnome_shell_version_array[1].to_int().is_even()
      gnome_shell_version = '.'.join([gnome_shell_version_array[0], gnome_shell_version_array[1]])
    else
      gnome_shell_version = '.'.join([gnome_shell_version_array[0], (gnome_shell_version_array[1].to_int() + 1).to_string()])
    endif
  else
    message('gnome-shell not found, using styles for last gnome-shell version availible')
    gnome_shell_version = '3.36'
  endif
endif

gnome_shell_scss_depend_files = files([
  '../_color-palette.scss',
  '../_colors.scss',
  '../_variables.scss',
  'sass/components/dialog/_dialog.scss',
  'sass/components/dialog/_network-dialog.scss',
  'sass/components/gdm/_login-dialog.scss',
  'sass/components/gdm/_screen-shield.scss',
  'sass/components/menu/_calendar.scss',
  'sass/components/menu/_candidate-popup.scss',
  'sass/components/menu/_menu.scss',
  'sass/components/menu/_message-list.scss',
  'sass/components/misc/_a11y.scss',
  'sass/components/misc/_keyboard.scss',
  'sass/components/misc/_looking-glass.scss',
  'sass/components/misc/_misc.scss',
  'sass/components/misc/_tile-preview.scss',
  'sass/components/notification/_hotplug.scss',
  'sass/components/notification/_notification.scss',
  'sass/components/osd/_osd.scss',
  'sass/components/osd/_switcher.scss',
  'sass/components/osd/_workspace-switcher.scss',
  'sass/components/overview/_app-grid.scss',
  'sass/components/overview/_dash.scss',
  'sass/components/overview/_overview.scss',
  'sass/components/overview/_search-entry.scss',
  'sass/components/overview/_search-results.scss',
  'sass/components/overview/_window-picker.scss',
  'sass/components/overview/_workspace-switcher.scss',
  'sass/components/panel/_panel.scss',
  'sass/components/panel/_ripple-box.scss',
  'sass/components/_base.scss',
  'sass/components/_button.scss',
  'sass/components/_check-box.scss',
  'sass/components/_entry.scss',
  'sass/components/_scrollbar.scss',
  'sass/components/_slider.scss',
  'sass/components/_switch.scss',
  'sass/_components.scss',
  'sass/_drawing.scss',
  'sass/_extensions.scss',
  'sass/_variables.scss',
])

foreach theme: themes
  gnome_shell_dir = join_paths(theme['dir'], 'gnome-shell')

  if theme['color'] != '-dark'
    gnome_shell_assets_dir = 'assets'
  else
    gnome_shell_assets_dir = 'assets-dark'
  endif

  install_subdir(
    gnome_shell_assets_dir,
    strip_directory: true,
    install_dir: join_paths(gnome_shell_dir, 'assets'),
  )

  install_subdir(
    'extensions',
    install_dir: gnome_shell_dir,
  )

  install_subdir(
    'icons',
    install_dir: gnome_shell_dir,
  )

  install_data(
    [
      'README.md',
      'gnome-shell-theme.gresource.xml',
      'noise-texture.png',
      'pad-osd.css',
      'process-working.svg',
    ],
    install_dir: gnome_shell_dir,
  )

  #
  # SCSS
  #

  gnome_shell_scss_conf = configuration_data()
  gnome_shell_scss_conf.set('dark_theme', theme['scss_dark_theme'])
  gnome_shell_scss_conf.set('light_topbar', theme['scss_light_topbar'])
  gnome_shell_scss_conf.set('compact', theme['scss_compact'])
  gnome_shell_scss_conf.set('version', gnome_shell_version)

  # Configure SCSS file
  gnome_shell_scss = configure_file(
    input: 'gnome-shell.scss.in',
    output: 'gnome-shell.@0@.scss'.format(theme['name']),
    configuration: gnome_shell_scss_conf,
  )

  # Copy it from build dir to source dir
  run_command(
    'cp',
    gnome_shell_scss,
    meson.current_source_dir(),
  )

  # Generate CSS file
  gnome_shell_css = custom_target(
    'gnome-shell.@0@.css'.format(theme['name']),
    input: 'gnome-shell.@0@.scss'.format(theme['name']),
    output: 'gnome-shell.@0@.css'.format(theme['name']),
    command: [sassc, sassc_opts, '@INPUT@', '@OUTPUT@'],
    depend_files: gnome_shell_scss_depend_files,
    build_by_default: true,
  )

  # Install it while renaming to a valid name
  meson.add_install_script(
    'sh', '-c', 'cp "@0@" "@1@"'.format(
      gnome_shell_css.full_path(),
      join_paths('$MESON_INSTALL_DESTDIR_PREFIX', gnome_shell_dir, 'gnome-shell.css'),
    ),
  )
endforeach
