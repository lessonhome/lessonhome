@route = '/tutor'

@struct = module 'tutor/home' :
  head : module 'head' :
    logo : module 'head/logo' :
      src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  edit_profile : module 'tutor/home/edit_profile' :
    name : 'Артемий Дудко'
    text : 'ред'
  left_menu : module 'menu/left_menu'
  top_menu : module 'menu/top_menu' :
    index : left_menu_array
  photo : module 'mime/photo' :
    src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  progress : module 'tutor/home/progress' :
    progress : '56%'
  personal_data : module 'tutor/home/personal_data' :
    name : 'Артемий Дудко'
  contacts : module 'tutor/home/contacts'
  education : module 'tutor/home/education'
  private : module 'tutor/home/private' :
    text : 'О себе:'
  video : module 'mime/video' :
    src : '#'



left_menu_array = {
  "Анкета": "/tutor"
  'Заявки ': '/tutor/bid'
  'Оплата': '/tutor/payment'
  'Документы': '/tutor/document'
  'Форум': '/tutor/forum'
  'Статьи': '/tutor/paper'
  'Помощь': '/tutor/help'
};
i = 1
for key,val of left_menu_array
  @struct.left_menu["btn"+i++] = module 'forms/button' :
    text : key
    href : val