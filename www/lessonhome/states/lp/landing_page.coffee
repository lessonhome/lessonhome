class @main extends @template '../lp'
  route : '/landing_page'
  model   : 'tutor/bids/reports'
  title : "Посадочная страница"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      tutor_target: @state './target_tutor'
      comments: @state 'lp/comments'
