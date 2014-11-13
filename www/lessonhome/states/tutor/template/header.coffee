@struct = module 'tutor/template/header' :
    logo : module 'tutor/template/header/logo' :
      src : F('lesson_home.jpg')
    top_menu: module 'tutor/template/menu/top_menu':
      items: {
        'Описание': 'profile'
        'Предметы и условия': 'subjects_and_conditions'
        'Отзывы': 'reviews'
      }
      active_item: 'Описание'