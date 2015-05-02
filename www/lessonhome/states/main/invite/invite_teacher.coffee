class @main extends template '../motivation_content'
  route : '/invite_teacher'
  model   : 'main/invite_teacher'
  title : "Пригласить репетитора"
  tags  : -> 'pupil:main_tutor'
  access : ['other', 'pupil', 'tutor']
  redirect : {
  }
  tree : ->
    filter_top  : state './top' :
      header : 'Ваш друг репетитор ищет учеников?<br>Пригласите его к нам и мы поможем!'

  init: ->
    @tree.filter_top.pupil_toggle.selector = "invite inactive"
    @tree.filter_top.tutor_toggle.selector = "invite"