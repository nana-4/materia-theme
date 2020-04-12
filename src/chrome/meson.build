foreach theme: themes
  chrome_dir = join_paths(theme['dir'], 'chrome')

  if theme['color'] != '-dark'
    chrome_scrollbar_color = ''
  else
    chrome_scrollbar_color = '-dark'
  endif

  install_data(
    'chrome-scrollbar@0@.crx'.format(chrome_scrollbar_color),
    rename: 'chrome-scrollbar.crx',
    install_dir: chrome_dir,
  )

  install_data(
    'chrome-theme@0@.crx'.format(theme['color']),
    rename: 'chrome-theme.crx',
    install_dir: chrome_dir,
  )
endforeach
