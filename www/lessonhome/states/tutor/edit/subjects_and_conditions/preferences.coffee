@route = '/tutor/edit/preferences'

@struct = state 'tutor/template/template'

@struct.header.top_menu.items =
  'Описание'           : 'general'
  'Предметы и условия' : 'subjects'

@struct.header.top_menu.active_item = 'Предметы и условия'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu?.items =
  'Предметы'     : 'subjects'
  'Место'        : 'location'
  'Календарь'    : 'calendar'
  'Предпочтения' : 'preferences'

@struct.sub_top_menu.active_item = 'Предпочтения'


@struct.left_menu.items = {
  'Анкета': '../profile'
  'Заявки': '../bids'
  'Оплата': '#'
  'Документы': '#'
  'Форум': '#'
  'Статьи': '#'
  'Поддержка': '#'
}

@struct.left_menu.active_item = 'Анкета'

@struct.content = module 'tutor/edit/subjects_and_conditions/preferences':
  sex  : module 'tutor/template/choice' :
    id : 'sex'
    indent : '79px'
    choice_list : [
      module 'tutor/template/button' :
        text  : 'М'
        type  : 'fixed'

      module 'tutor/template/button' :
        text  : 'Ж'
        type  : 'fixed'

    ]

  category : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  status : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  hint : module 'tutor/template/hint' :
    type : 'vertical'
    header : 'Это подсказка'
    text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит'

  button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type : 'fixed'