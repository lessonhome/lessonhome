class @main extends template 'tutor/template/template'
  route : '/tutor/edit/career'
  model   : 'tutor/edit/career'
  title : "редактирование карьеры"
  tree : =>
    items : [
      module 'tutor/template/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/template/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'Карьера'
    content : module 'tutor/edit/description/career' :
      place_of_work : module 'tutor/template/forms/input'
      post : module 'tutor/template/forms/input'
      add_button : module 'tutor/template/button' :
        text  : '+ Добавить'
        selector  : 'fixed'
      experience_tutoring : module 'tutor/template/forms/drop_down_list'
      number_of_students : module 'tutor/template/forms/drop_down_list'
      extra_info : module 'tutor/template/forms/textarea' :
        height : '82px'

      save_button : module 'tutor/template/button' :
        text  : 'Сохранить'
        selector  : 'fixed'


      hint : module 'tutor/template/hint' :
        selector : 'horizontal'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени,
                 то и состояние какой-либо системы тоже может зависеть от времени,
                 как обычно и происходит. Однако в некоторых исключительных случаях
                 зависимость какой-либо величины от времени может оказаться пренебрежимо
                 слабой, так что с высокой точностью можно считать эту характеристику независящей от времени.
                 Если такие величины описывают динамику какой-либо системы,'



  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']




