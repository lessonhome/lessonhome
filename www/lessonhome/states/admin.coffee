class @main
  route : '/admin'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  tags   : [ 'tutor:reports','skip:default']
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    materialize : @module 'lib/materialize'
    header  : @module "$/header"
    content : @exports()

