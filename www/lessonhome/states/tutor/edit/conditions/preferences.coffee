class @main extends template '../../../tutor'
  route : '/tutor/edit/preferences'
  model   : 'tutor/edit/conditions/preferences'
  title : "редактирование условия"
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Предпочтения'

    content : module '$':
      sex  : module 'tutor/choice' :
        id      : 'sex'
        indent  : '75px'
        choice_list : [
          module 'tutor/button' :
            text      : 'М'
            selector  : 'fixed'

          module 'tutor/button' :
            text      : 'Ж'
            selector  : 'fixed'

        ]
      category : module 'tutor/forms/drop_down_list'
      status : module 'tutor/forms/drop_down_list'

      hint : module 'tutor/hint' :
        selector  : 'vertical'
        header    : ''
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит'

      button : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'fixed'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


