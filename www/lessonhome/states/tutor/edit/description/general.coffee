
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/general'
  model   : 'tutor/edit/general'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item     : 'Общие'
    content : module 'tutor/edit/description/general' :

      first_name  : module 'tutor/template/forms/input'
      second_name : module 'tutor/template/forms/input'
      patronymic  : module 'tutor/template/forms/input'
      sex         :
        male   : module 'tutor/template/button' :
          text      : 'М'
          selector  : 'fixed'

        female : module 'tutor/template/button' :
          text      : 'Ж'
          selector  : 'fixed'

      birth_day   : module 'tutor/template/forms/drop_down_list'
      birth_month : module 'tutor/template/forms/drop_down_list'
      birth_year  : module 'tutor/template/forms/drop_down_list'
      status      :  module 'tutor/template/forms/drop_down_list'

      save_button : module 'tutor/template/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

      hint : module 'tutor/template/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

  init : ->
    @parent.setTopMenu 'Описание', {
      'Описание': 'general'
      'Условия' : 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']


