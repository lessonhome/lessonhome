class @main
  route : '/admin'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  tags   : [ 'tutor:reports','skip:default']
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    materialize : @module 'lib/materialize'

