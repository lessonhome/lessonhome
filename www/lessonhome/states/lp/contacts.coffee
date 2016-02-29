class @main extends @template 'lp'
  route : '/contacts'
  model : 'main_m'
  title : "Контакты"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      id_page: 'contacts_page'
