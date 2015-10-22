class @main
  route : '/lp'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    lib : @state 'libm'
    header  : @module "$/header"
    content : @exports()
