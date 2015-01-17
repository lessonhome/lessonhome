class @main extends template '../motivation_content'
  route : '/invite_student'
  model   : 'main/invite_student'
  title : "Пригласить друга"
  tree : ->
    filter_top  : state './top' :
      header : 'Ваш друг ищет репетитора?<br>Пригласите его к нам и мы поможем!'