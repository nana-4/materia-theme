foreach theme: themes
  unity_dir = join_paths(theme['dir'], 'unity')

  if theme['color'] != '-light'
    unity_window_buttons_dir = 'window-buttons'
  else
    unity_window_buttons_dir = 'window-buttons-light'
  endif

  install_subdir(
    unity_window_buttons_dir,
    strip_directory: true,
    install_dir: unity_dir,
  )

  install_subdir(
    'dash-buttons',
    strip_directory: true,
    install_dir: unity_dir,
  )

  install_subdir(
    'launcher',
    strip_directory: true,
    install_dir: unity_dir,
  )

  install_data(
    'dash-widgets.json',
    install_dir: unity_dir,
  )
endforeach
