
class @main extends @template './errors_template'
  route : '/404'
  model   : 'errors/404'
  title : "ошибка 404"
  access : ['other', 'tutor', 'pupil']
  redirect : {}
  tree : =>
    photo :
      src     : @F 'errors/404.png'
    top_text : 'Мы не нашли эту страницу.'
    center_text : 'Попробуйте вернуться <a class="back red">назад</a> или на <a class="red" href="/">главную.</a>'
    bottom_text : 'Если у вас есть вопросы или нужна помощь,<br>напишите в <a class="blue" href="/support">тех. поддержку</a>'