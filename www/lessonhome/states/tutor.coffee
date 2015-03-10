class @main
  tree : -> module '$' :
    depend        : [
      module '$/edit'
      state 'lib'
    ]
    header        : state 'tutor/header'  :
      icons       : module '$/header/icons' :
        counter : '5'
      items : [
        module 'tutor/header/button' :
          title : 'Описание'
          href  : '/tutor/profile'
          tag   : @exports 'tutor_profile'
        module 'tutor/header/button' :
          title : 'Условия'
          href  : '/tutor/conditions'
          tag   : @exports 'tutor_conditions'
        module 'tutor/header/button' :
          title : 'Отзывы'
          href  : '/tutor/reviews'
          tag   : @exports 'tutor_reviews'
      ]
    left_menu     : state 'tutor/left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    footer        : state 'footer'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items
