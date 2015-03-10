class @main extends template '../../edit'
  route : '/tutor/edit/preferences'
  model   : 'tutor/edit/conditions/preferences'
  title : "редактирование условия"
  tags : -> 'edit: conditions'
  tree : =>
    menu_condition  : 'edit: conditions'
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item : 'Предпочтения'
    #title       : 'Уточните с какими учениками Вы хотите заниматься'
    tutor_edit  : module '$':
      gender_data   : state 'gender_data'
      ###
      category : module 'tutor/forms/drop_down_list'  :
        text      : 'Класс :'
        selector  : 'first_reg'
      ###
      status : module 'tutor/forms/drop_down_list'  :
        text      : 'Статус :'
        selector  : 'first_reg'
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'




