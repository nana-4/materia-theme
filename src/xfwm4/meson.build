foreach theme: themes
  xfwm4_dir = join_paths(theme['dir'], 'xfwm4')

  install_subdir(
    'xfwm4' + theme['color'],
    strip_directory: true,
    install_dir: xfwm4_dir,
  )
endforeach
