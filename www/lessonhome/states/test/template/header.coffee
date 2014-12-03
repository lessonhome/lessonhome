class @main
  tree : -> module 'tutor/template/header' :
    logo : module 'tutor/template/header/logo'
    top_menu : module 'tutor/template/menu/top_menu' :
      items:
        'Описание': 'profile'
        'Предметы и условия': 'subjects_and_conditions'
        'Отзывы': 'reviews'
      active_item: 'Описание'
