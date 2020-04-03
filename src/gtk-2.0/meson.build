foreach theme: themes
  gtk2_dir = join_paths(theme['dir'], 'gtk-2.0')

  if theme['color'] != '-dark'
    gtk2_assets_dir = 'assets'
  else
    gtk2_assets_dir = 'assets-dark'
  endif

  install_subdir(
    gtk2_assets_dir,
    strip_directory: true,
    install_dir: join_paths(gtk2_dir, 'assets'),
  )

  install_data(
    'gtkrc' + theme['color'],
    rename: 'gtkrc',
    install_dir: gtk2_dir,
  )

  install_data(
    [
      'apps.rc',
      'hacks.rc',
      'main.rc',
    ],
    install_dir: gtk2_dir,
  )
endforeach
