class @main extends @template '../lp'
  route: '/lp/template'
  model: 'tutor/bids/reports'
  title: 'Lessonhome - бесплатный подбор репетитора для сдачи егэ по английскому языку'
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree: =>
    content: @module '$':
      title: @exports()
      dark_title_style: @exports()
      tutors_title: @exports()
      top_img: @exports()
      top_right: @exports()
      title_color: @exports()
      bg_color: @exports()
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      opacity_header: true
      tutor_card: @state './tutor_card'
