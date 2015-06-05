class @main extends @template '../motivation_content'
  route : '/invite_student'
  model   : 'main/invite_student'
  title : "Пригласить друга"
  tags : -> 'pupil:fast_bid'
  access : ['other', 'pupil', 'tutor']
  redirect : {
  }
  tree : ->
    filter_top  : @state './top' :
      header : 'Ваш друг ищет репетитора?<br>Пригласите его к нам и мы поможем!'

  init: ->
    @tree.filter_top.pupil_toggle.selector = "invite"
    @tree.filter_top.tutor_toggle.selector = "invite inactive"