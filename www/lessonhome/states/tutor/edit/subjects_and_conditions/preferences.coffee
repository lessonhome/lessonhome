class @main extends template 'tutor/template/template'
  route : '/tutor/edit/preferences'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Предпочтения'

    content : module 'tutor/edit/subjects_and_conditions/preferences':
      sex  : module 'tutor/template/choice' :
        id : 'sex'
        indent : '75px'
        choice_list : [
          module 'tutor/template/button' :
            text  : 'М'
            type  : 'fixed'

          module 'tutor/template/button' :
            text  : 'Ж'
            type  : 'fixed'

        ]
      category : module 'tutor/template/forms/drop_down_list'
      status : module 'tutor/template/forms/drop_down_list'

      hint : module 'tutor/template/hint' :
        type : 'vertical'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит'

      button : module 'tutor/template/button' :
        text  : 'Сохранить'
        type : 'fixed'

  init : ->
    @parent.setTopMenu 'Условия', {
      'Описание': 'general'
      'Условия': 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']


