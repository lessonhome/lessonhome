class @main  extends @template '../lp'
  route : '/lp_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {

  }
  tree : =>
    ###
    test : $defer : =>
      taskTypes = yield Feel.getAllTaskTypes()
      ret = {}
      for type in taskTypes
        struct = yield Feel.getTaskStruct type
        ret[type] = @module 'task': struct
      return ret
    ###
    content : @module '$':
      top_form  : @module 'main/fastest_top'
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'
      filter : @exports()
      photo_src : @exports()
      title : @exports()
      sub_title : @exports()
      text : @exports()
      title_suit_tutors : @exports()
      landing_img: @exports()
      title_position: @exports()
      button_color: @exports()
      bg_position : @exports()
      opacity_form: @exports()
      hide_head_button: true
      hide_menu_punkt: true
      tutors : $defer : =>
        @tree.content.filter ?= {}
        @tree.content.filter.page = 'landing'
        filter = yield Feel.udata.d2u "mainFilter",@tree.content.filter
        hash = yield Feel.udata.filterHash filter,'filter'
        filter = yield Feel.udata.u2d filter
        jobs = yield Main.service 'jobs'
        o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:5,from:0}
        o ?= {}
        o.preps ?= {}
        modules = for index,prep of o.preps
          @module 'main/tutor_list/tutor':
            value:prep
            main_subject : _setKey @tree.content.filter,'subject.0'
        return modules


