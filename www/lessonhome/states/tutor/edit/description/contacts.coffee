class @main extends template '../edit_description'
  route : '/tutor/edit/contacts'
  model   : 'tutor/edit/description/contacts'
  title : "редактирование контактов"
  tags : -> 'edit: description'
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Контакты'
    tutor_edit  : state 'contacts_tutor'
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'