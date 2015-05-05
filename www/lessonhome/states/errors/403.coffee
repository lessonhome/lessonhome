
class @main extends template './errors_template'
  route : '/403'
  model   : 'errors/403'
  title : "ошибка 403"
  access : ['other', 'tutor', 'pupil']
  redirect : {}
  tree : =>
    photo :
      src     : F 'errors/403.png'
    top_text : 'У вас нет доступа к этой странице.'
    center_text : 'Попробуйте вернуться <a class="back red">назад</a> или на <a class="red" href="/">главную.</a>'
    bottom_text : 'Если у вас есть вопросы или нужна помощь,<br>напишите в <a class="blue">тех. поддержку</a>'
