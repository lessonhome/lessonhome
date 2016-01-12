class @main extends @template 'lp'
  route : '/'
  model : 'main_m'
  title : "LessonHome - Главная страница"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : =>
    content : @module '$'
