class @main
  tree : -> module 'tutor/template/header' :
    logo : module 'tutor/template/header/logo'
    icons : module 'tutor/template/header/icons'
    back_call : module 'tutor/template/header/back_call'
    button_in :  module 'tutor/template/button' :
      text  : 'Выход'
      selector : 'simple'
    top_menu : module 'tutor/template/menu/top_menu' :
      items: {
        'Описание': 'profile'
        'Условия': 'conditions'
        'Отзывы': 'reviews'
      }
      active_item: 'Описание'