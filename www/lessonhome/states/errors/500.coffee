
class @main extends template './errors_template'
  route : '/500'
  model   : 'errors/500'
  title : "ошибка 500"
  access : ['other', 'tutor', 'pupil']
  redirect : {}
  tree : =>
    photo :
      src     : F 'errors/500.png'
    top_text : 'Внутренняя ошибка сервера.'
    center_text : 'Попробуйте вернуться <a class="back red">назад</a> или на <a class="red" href="/">главную.</a>'
    bottom_text : 'Если у вас есть вопросы или нужна помощь,<br>напишите в <a class="blue">тех. поддержку</a>'
