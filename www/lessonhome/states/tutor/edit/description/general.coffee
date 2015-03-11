class @main extends template '../edit_description'
  route : '/tutor/edit/general'
  model   : 'tutor/edit/description/general'
  title : "редактирование общее"
  tags : -> 'edit: description'
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Общие'
    tutor_edit  : state 'general_data'
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'

