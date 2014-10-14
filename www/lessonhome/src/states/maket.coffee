
@route = '/tutor'

@struct = module 'tutor/home' :
  head : module 'head' :
    logo : module 'head/logo' :
      src : 'http://cs10100.vk.me/u833630/-6/x_857304db.jpg'
  edit_profile : module 'tutor/home/edit_profile' :
    button_edit_profile : module 'forms/button' :
      text : "edit"
  short_info : module 'tutor/home/short_info'
  left_menu : module 'menu/left_menu'
  top_menu : module 'menu/top_menu'
  photo : module 'mime/photo' :
    src : 'http://cs10100.vk.me/u833630/-6/x_857304db.jpg'
  rating : module 'tutor/home/rating' :
    rating : 56
  personal_data : module 'tutor/home/personal_data' :
    name : 'Василий Алибабаевич'
  contacts : module 'tutor/home/contacts'
  education : module 'tutor/home/education'
  private : module 'tutor/home/private' :
    text : 'Хороший репетитор'
  video : module 'mime/video' :
    src : 'http://cs10100.vk.me/u833630/-6/x_857304db.jpg'


left_button_array = {
  "Анкета": "/tutor"
  'Заявки учеников': '/tutor/bid'
  'Статус заявки': '/tutor/status'
};
i = 1
for key,val of left_button_array
  @struct.left_menu["btn"+i++] = module 'forms/button' :
    text : key
    background_color : "blue"
    href : val
