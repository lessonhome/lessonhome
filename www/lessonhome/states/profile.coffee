class @main extends @template 'lp'
  route : '/tutor'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Профиль репетитора"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
  }
  tree : =>
    #content : @module '$'
    single_profile : 'tutor_profile'

