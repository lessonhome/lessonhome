class @main
  route : '/lp'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  tags   : [ 'tutor:reports','skip:default']
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    materialize : @module 'lib/materialize_two'
    header  : @module "$/header"
    content : @exports()