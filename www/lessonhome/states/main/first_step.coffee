class @main extends template './motivation_content'
  route : '/first_step'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    filter_top  : state './filter_top':
      title : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list'  :
        selector    : 'filter_top'
        placeholder : 'Предмет'
      choose_subject  : module 'tutor/button'  :
        selector  : 'choose_subject'
        text        : 'Алгебра'

    info_panel  : state './info_panel'  :
      math              : 'Математические +'
      natural_research  : 'Естественно-научные +'
      philology         : 'Филологичные +'
      foreign_languages : 'Иностранные языки +'
      others            : 'Другие +'
      selector          : 'first_step'