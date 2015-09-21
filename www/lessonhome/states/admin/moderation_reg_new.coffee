class @main  extends @template '../admin'
  route : '/admin/moderation_reg_new'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  tags   : [ 'tutor:reports','skip:default']
  access : ['other']
  redirect : {
  }
  tree : =>
    content : @module '$'