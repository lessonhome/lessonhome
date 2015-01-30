class @main extends template './motivation_content'
  route : '/first_step'
  tags  : -> 'pupil:main_search'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    filter_top  : state './filter_top':
      title         : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list' :
        selector    : 'filter_top'
        placeholder : 'Предмет'
      choose_subject  : module '../selected_tag'  :
        selector  : 'choose_subject'
        text      : 'Алгебра'
        close     : true

    info_panel  : state './info_panel'  :
      math              : 'Математические +'
      natural_research  : 'Естественно-научные +'
      philology         : 'Филологичные +'
      foreign_languages : 'Иностранные языки +'
      others            : 'Другие +'
      selector          : 'first_step'
