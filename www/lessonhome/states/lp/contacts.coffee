class @main extends @template 'lp'
  route : '/contacts'
  model : 'main_m'
  title : "Контакты"
  tags   : [ 'tutor:reports']
  access : ['other','pupil']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$'