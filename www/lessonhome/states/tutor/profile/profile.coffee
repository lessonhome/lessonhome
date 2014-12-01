@route = '/tutor/profile'

@struct = state 'tutor/template/template'

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')

@struct.content = module 'tutor/profile':
  photo : module 'mime/photo' :
    src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  progress : module 'tutor/profile/description/progress' :
    progress : '56%'
  personal_data : module 'tutor/profile/description/personal_data' :
    name : 'Артемий Дудко'
  contacts : module 'tutor/profile/description/contacts'
  education : module 'tutor/profile/description/education'
  private : module 'tutor/profile/description/private' :
    text : 'О себеО себеО себеО себеО себеО себеО себеО себеО себе
    О себеО себеО себеО себеО себеО себеО себеО себеО себеО себеО
    О себеО себеО себеО себеО себеО себеО себеО себеО себеО себе:'
  media : module 'tutor/profile/description/media' :
    photo1 : module 'mime/photo' :
      src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
    photo2 : module 'mime/photo' :
      src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
    video : module 'mime/video' :
      src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'