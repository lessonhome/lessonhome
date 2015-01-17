class @main extends template '../../../tutor'
  route : '/tutor/edit/career'
  model   : 'tutor/edit/description/career'
  title : "редактирование карьеры"
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
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
        #'Медиа'       : 'media'
      active_item : 'Карьера'
    content : module '$' :
      place_of_work : module 'tutor/forms/input'
      post : module 'tutor/forms/input'
      add_button    : module 'tutor/button' :
        text     : '+Добавить'
        selector : 'edit_add'
      line : module 'tutor/separate_line' :
        selector : 'gradient'
      experience_tutoring : module 'tutor/forms/drop_down_list'
      number_of_students : module 'tutor/forms/drop_down_list'
      extra_info : module 'tutor/forms/textarea' :
        height : '117px'

      save_button : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'


      hint : module 'tutor/hint' :
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




