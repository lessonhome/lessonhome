class @main extends @template '../lp'
  route: '/ad/english/ege'
  model: 'tutor/bids/reports'
  title: 'Lessonhome - бесплатный подбор репетитора для сдачи егэ по английскому языку'
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree: =>
    content: @module '$':
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      opacity_header: true
