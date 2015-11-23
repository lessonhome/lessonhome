class @main
  route : '/lp'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {
  }
  tree : => @module '$' :
    lib : @state 'libm'
    header  : @module "$/header"
    content : @exports()
    footer  : @module "$/footer"
    bottom_block_attached : @module 'main/attached_panel' :
      bottom_bar  : @state 'main/attached_panel/bar'
      popup       : @state 'main/attached_panel/popup'
    profile         : @module 'profile':
      price_subject : @module 'profile/price_subject'
      single_profile : @exports()
    single_profile  : @exports()
