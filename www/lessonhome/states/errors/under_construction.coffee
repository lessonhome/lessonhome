
class @main extends template './errors_template'
  route : '/under_construction'
  model   : 'errors/under_construction'
  title : "раздел находится в разработке"
  access : ['other', 'tutor', 'pupil']
  redirect : {}
  tree : =>
    photo : module 'mime/photo' :
      src     : F 'errors/under_construction.jpg'
    top_text : 'Данный раздел сайта в разработке.'
    center_text : 'Если вы <a class="blue">зарегистрировались</a>, то мы сообщим<br>Вам об обновлениях!'
    bottom_text : 'Вы можете вернуться <a class="back red">назад</a> или на <a class="red" href="/">главную.</a>'
