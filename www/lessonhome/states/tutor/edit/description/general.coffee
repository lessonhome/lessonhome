class @main extends template '../../../tutor'
  route : '/tutor/edit/general'
  model   : 'tutor/edit/description/general'
  title : "редактирование общее"
  tags : -> 'edit: description'
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
        tag   : 'edit: description'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Настройки'   : 'settings'
        #'Медиа'       : 'media'
      active_item     : 'Общие'
    content       : module '$' :
      first_name  : module 'tutor/forms/input'
      second_name : module 'tutor/forms/input'
      patronymic  : module 'tutor/forms/input'
      sex_woman     : module 'gender_button' :
        selector  : 'preferences'
        text      : 'Ж'
      sex_man       : module 'gender_button' :
        selector  : 'preferences'
        text      : 'М'
      birth_day   : module 'tutor/forms/drop_down_list' :
        selector    : 'small_radius'
        placeholder : 'День'
      birth_month : module 'tutor/forms/drop_down_list' :
        selector    : 'small_radius'
        placeholder : 'Месяц'
      birth_year  : module 'tutor/forms/drop_down_list' :
        selector    : 'small_radius'
        placeholder : 'Год'
      status      :  module 'tutor/forms/drop_down_list'

      save_button   : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'

      hint : module 'tutor/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


