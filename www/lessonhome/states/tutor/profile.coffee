@route = '/tutor/profile'

@struct = state 'tutor/template_home'

@struct.content = module 'tutor/profile':
  edit_profile : module 'tutor/profile/edit_profile' :
    name : 'Артемий Дудко'
    text : 'ред'
  top_menu : module 'menu/top_menu' :
    items : {
      'Описание': '#'
      'Предметы и условия': '#'
      'Отзывы': '#'
    }
    active_item : 'Описание'
  photo : module 'mime/photo' :
    src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  progress : module 'tutor/profile/progress' :
    progress : '56%'
  personal_data : module 'tutor/profile/personal_data' :
    name : 'Артемий Дудко'
  contacts : module 'tutor/profile/contacts'
  education : module 'tutor/profile/education'
  private : module 'tutor/profile/private' :
    text : 'О себе:'
  video : module 'mime/video' :
    src : '#'