class @main extends @template 'lp'
  route : '/tutors_search'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Профиль репетитора"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : =>
    content : @module '$'