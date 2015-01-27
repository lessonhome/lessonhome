class @main extends template '../../tutor'
  route : '/tutor/reviews'
  model : 'tutor/profile/reviews'
  title : "отзывы"
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
    content : state './reviews_content'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
