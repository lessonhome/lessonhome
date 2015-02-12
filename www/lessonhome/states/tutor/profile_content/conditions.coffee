class @main extends template '../../tutor'
  route : '/tutor/conditions'
  model   : 'tutor/profile/conditions'
  title : "условия"
  tags   : -> 'tutor:conditions'
  tree : ->
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/profile'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/conditions'
        tag   : 'tutor:conditions'
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