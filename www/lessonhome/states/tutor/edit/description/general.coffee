class @main extends template '../../../tutor'
  route : '/tutor/edit/general'
  model   : 'tutor/edit/description/general'
  title : "редактирование общее"
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/genera'
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
        'Медиа'       : 'media'
      active_item     : 'Общие'
    content       : module '$' :
      first_name  : module 'tutor/forms/input'
      second_name : module 'tutor/forms/input'
      patronymic  : module 'tutor/forms/input'
      sex_man     : module 'tutor/forms/sex_button' :
        selector: 'man'
      sex_woman   :   module 'tutor/forms/sex_button' :
        selector: 'woman'

      birth_day   : module 'tutor/forms/drop_down_list' :
        placeholder : 'День'
      birth_month : module 'tutor/forms/drop_down_list' :
        placeholder : 'Месяц'
      birth_year  : module 'tutor/forms/drop_down_list' :
        placeholder : 'Год'
      status      :  module 'tutor/forms/drop_down_list'

      save_button : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

      hint : module 'tutor/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


