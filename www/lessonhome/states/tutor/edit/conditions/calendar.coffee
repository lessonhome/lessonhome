class @main extends template '../edit_conditions'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/conditions/calendar'
  title : "редактирование календарь"
  tags : -> 'edit: conditions'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree  : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Календарь'
    tutor_edit  : module '$'  :
      calendar    : state 'calendar'  :
        selector  : 'advance_filter'
      #hint       : module 'tutor/hint_dz' :
      #  selector  : 'small'
      #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'