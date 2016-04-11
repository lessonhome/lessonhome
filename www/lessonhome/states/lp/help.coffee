class @main extends @template 'lp'
  route : '/help'
  model : 'main_m'
  title : "Помощь"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      id_page: 'help_page'
