foreach theme: themes
  metacity_dir = join_paths(theme['dir'], 'metacity-1')

  install_subdir(
    'assets',
    install_dir: metacity_dir,
  )

  install_data(
    'metacity-theme-2@0@.xml'.format(theme['color']),
    rename: 'metacity-theme-2.xml',
    install_dir: metacity_dir,
  )

  install_data(
    'metacity-theme-3.xml',
    install_dir: metacity_dir,
  )
endforeach
