class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile/profile'
  title : "анкета"
  tree : ->
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/profile'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/conditions'
      }
      module 'tutor/header/button' : {
        title : 'Отзывы'
        href  : '/tutor/reviews'
      }
    ]
    content : state './profile_content' :
      popup         : @exports()
      contacts : module './profile_content/info_block' :
        section :
          'Телефон :'     : '11.11.11'
          'Почта :'       : 'yandex@rambler.ru'
          'Скап :'        : 'baklane'
          'Личный сайт :' : 'prepod.ru'
      progress  : module './profile_content/progress' :
        filling  : '56%'
      edit      : true
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'

