class @main extends template '../../tutor'
  route : '/tutor/conditions'
  model   : 'tutor/profile/conditions'
  title : "условия"
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

    content : state './conditions_content'  :
      edit  : true
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'