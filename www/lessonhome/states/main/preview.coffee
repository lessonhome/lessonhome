class @main extends template '../main'
  tree : =>
    filter_top : @exports()

    info_panel  : state './info_panel'  :
      subject           : 'Предметы +'
      tutor             : 'Преподователь +'
      place             : 'Место'
      price             : 'Цена'
      selector          : 'second_step'

    content : module '$' :
      advanced_filter  : state './advanced_filter'
      sort             :  module '$/sort'
      choose_tutors    :  module '$/choose_tutors':
        all_rating  : module '../rating_star'
        tutor_photo : module 'mime/photo' :
          src : '#'
      tutors           :  module '$/tutors'


