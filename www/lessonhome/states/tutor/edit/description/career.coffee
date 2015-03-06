class @main extends template '../../edit'
  route : '/tutor/edit/career'
  model   : 'tutor/edit/description/career'
  title : "редактирование карьеры"
  tags : -> 'edit: description'
  tree : =>
    menu_description  : 'edit: description'
    items :
      'Общие'       : 'general'
      'Контакты'    : 'contacts'
      'Образование' : 'education'
      'Карьера'     : 'career'
      'О себе'      : 'about'
      'Настройки'   : 'settings'
    active_item : 'Карьера'
    tutor_edit  : module '$' :
      place_of_work : module 'tutor/forms/input'  :
        selector    : 'first_reg'
        text        : 'Место работы :'
      post : module 'tutor/forms/input' :
        selector    : 'first_reg'
        text        : 'Должность :'
      add_button    : module 'button_add' :
        text     : '+Добавить'
        selector : 'edit_add'
      line : module 'tutor/separate_line' :
        selector : 'horizon'
      experience_tutoring : module 'tutor/forms/drop_down_list' :
        selector    : 'first_reg'
        text        : 'Опыт репетиторства :'
      number_of_students : module 'tutor/forms/drop_down_list'  :
        selector    : 'first_reg'
        text        : 'Количество учеников :'
      extra_info : module 'tutor/forms/textarea' :
        text      : 'Доп. информация/<br>награды'
        selector  : 'first_reg'
        height : '117px'
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'