class @main
  route : '/lp'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  access : ['all']
  redirect : {
  }
  forms : ['person']
  tree : =>
    metro = @const('metro')
    filter = @const('filter')
    @module '$' :
      lib : @state 'libm'
      header  : @module "$/header":
        hide_head_button: @exports('content.hide_head_button')
        hide_menu_punkt: @exports('content.hide_menu_punkt')
        enter_button_show: @exports('content.enter_button_show')
        id_page: @exports('content.id_page')
        photo   : $form : person : 'avatar'
        src     : @F 'vk.unknown.man.jpg'
        first_name: $form : person : 'first_name'
        middle_name: $form : person : 'middle_name'
      content : @exports()
      footer  : @module "$/footer":
        id_page: @exports('content.id_page')
      bottom_block_attached : @module 'main/attached_panel' :
        bottom_bar  : @state 'main/attached_panel/bar'
        popup       : @state 'main/attached_panel/popup'
      profile         : @module 'profile':
        single_profile : @exports()
        value : $defer : =>
          index = _setKey @req.udata,'tutorProfile.index'
          jobs = _HelperJobs
          #t = (new Date()).getTime()
          #prep = yield jobs.solve 'getTutor',{index}
          #t -= (new Date()).getTime()
          #t2 = (new Date()).getTime()
          prep = yield jobs.solve 'getTutor',{index}
          #t2 -= (new Date()).getTime()
          #console.log {t,t2}
          pupil = _setKey @req.udata, 'pupil'
          prep["data_pupil"] = pupil
          return prep
      single_profile  : @exports()
      req_call : @module 'lp/request_call'
      bid_popup : @module 'lp/bid_popup':
        value: {
          name: $urlform: pupil: 'name'
          phone: $urlform: pupil: 'phone'
          subjects: $urlform: pupil: 'subjects'
#          metro: $urlform: pupil: 'metro'
#          comment: $urlform: pupil: 'prices'
#          gender: $urlform: pupil: 'gender'
#          prices: $urlform: pupil: 'comment'
        }
        subjects : filter.subjects
        prices: filter.price
        status: filter.obj_status
        metro: metro.for_select
        metro_lines: metro.lines
