class @main extends template '../motivation_content'
  route : '/invite_teacher'
  model   : 'main/invite_teacher'
  title : "Пригласить репетитора"
  tree : ->
    filter_top  : state './top' :
      header : 'Ваш друг репетитор ищет учеников?<br>Пригласите его к нам и мы поможем!'