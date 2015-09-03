class @main
  route : '/admin'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  tags   : -> 'tutor:reports'
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    admin_panel : @module 'admin/admin_panel' :
      button_create_question  : @module 'tutor/button'
      button_create_bid : @module 'tutor/button'
      button_register : @module 'tutor/button'
