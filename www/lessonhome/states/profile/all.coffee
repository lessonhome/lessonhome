class @main  extends @template '../profile'
  route : '/profile_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Профиль пользователя"
  access : ['other']
  redirect : {

  }
  tree : =>
    content : @module '$'