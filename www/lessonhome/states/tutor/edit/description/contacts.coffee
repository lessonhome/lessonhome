
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/contacts'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'Контакты'
    content : module 'tutor/edit/description/contacts' :
      country : module 'tutor/template/forms/drop_down_list'
      city : module 'tutor/template/forms/drop_down_list'
      address_button : module 'tutor/template/button' :
        type  : 'fixed'
        text  : 'Укажите место'
      mobile_phone     : module 'tutor/template/forms/input'
      additional_phone : module 'tutor/template/forms/input'
      mail  : module 'tutor/template/forms/input'
      skype : module 'tutor/template/forms/input'
      personal_website : module 'tutor/template/forms/input'
      save_button : module 'tutor/template/button' :
        text  : 'Сохранить'
        type  : 'fixed'
      hint : module 'tutor/template/hint' :
        type : 'horizontal'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'
  init : ->
    @parent.setTopMenu 'Описание', {
        'Описание': 'general'
        'Условия': 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']


