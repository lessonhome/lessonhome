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
      single_profile : @exports()
      value : $defer : =>
        index = _setKey @req.udata,'tutorProfile.index'
        jobs = yield Main.service 'jobs'
        prep = yield jobs.solve 'getTutor',{index}
        return prep
    single_profile  : @exports()
    req_call : @module 'lp/request_call'
    bid_popup : @module 'lp/bid_popup'
