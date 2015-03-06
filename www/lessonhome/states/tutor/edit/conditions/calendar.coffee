class @main extends template '../../edit'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/conditions/calendar'
  title : "редактирование календарь"
  tags : -> 'edit: conditions'
  tree  : =>
    menu_condition  : 'edit: conditions'
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item : 'Календарь'
    #title       : 'Определите свободное время для проведения Ваших занятий'
    tutor_edit  : state 'calendar'  :
      selector  : 'advance_filter'
    hint       : module 'tutor/hint_dz' :
      selector  : 'small'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'
    selector_hint : 'top'