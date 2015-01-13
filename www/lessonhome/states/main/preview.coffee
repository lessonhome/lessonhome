class @main extends template '../main'
  tree : =>
    filter_top : @exports()
    content : module '$' :
      advanced_filter  : state './advanced_filter'

    info_panel  : state './info_panel'  :
      subject           : 'Предметы +'
      tutor             : 'Преподователь +'
      place             : 'Место'
      price             : 'Цена'
      selector          : 'second_step'