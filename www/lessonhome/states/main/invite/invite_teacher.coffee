class @main extends template '../invite'
  route : '/invite_teacher'
  model   : 'main/invite_teacher'
  title : "Пригласить репетитора"
  init : ->
    @parent.tree.filter_top.header = 'Ваш друг репетитор ищет учеников?<br>Пригласите его к нам и мы поможем!'