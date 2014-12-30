class @main extends template '../invite'
  route : '/invite_student'
  model   : 'main/invite_student'
  title : "Пригласить друга"
  init : ->
    @parent.tree.filter_top.header = 'Ваш друг ищет репетитора?<br>Пригласите его к нам и мы поможем!'