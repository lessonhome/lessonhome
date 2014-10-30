@route = '/tutor/profile'

@struct = state 'tutor/template/template'

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
    text : 'О себе:'
  video : module 'mime/video' :
    src : '#'