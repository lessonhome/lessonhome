class @main extends @template 'lp'
  route : '/users_cabinet'
  model : 'main_m'
  title : "Личный кабинет"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      id_page: 'uc_page'
