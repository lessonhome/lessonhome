

class @main extends template './motivation_content'
  route : '/first_step'
  tags  : -> 'pupil:main_search'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    popup       : @exports()
    filter_top  : state './filter_top' :
      title         : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list' :
        selector    : 'filter_top'
        placeholder : 'Предмет'
      choose_subject  : module '../selected_tag'  :
        selector  : 'choose_subject'
        id        : '123'
        text      : 'Алгебра'
        close     : true
      empty_choose_subject : module '../selected_tag' :
        selector  : 'choose_subject'
        id        : ''
        text      : ''
        close     : true
      link_forward    :  '/second_step'


    info_panel  : state './info_panel'  :
      math : module '//item' :
        title: 'Математические +'
        list : [
          'Математика 1'
          'Математика 2'
          'Математика 3'
          'Математика 4'
          'Математика 5'
          'Математика 6'
        ]
      natural_research  : module '//item' :
        title : 'Естественно-научные +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      philology         : module '//item' :
        title : 'Филологичные +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      foreign_languages : module '//item' :
        title : 'Иностранные языки +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      others            : module '//item' :
        title :'Другие +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      selector : 'first_step'
