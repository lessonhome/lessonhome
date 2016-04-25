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
      tutors_title: @exports()
      title_custom_position: @exports()
      top_img: @exports()
      shadow_bg: @exports()
      dotted_bg: @exports()
      top_right: @exports()
      title_color: @exports()
      bg_color: @exports()
      bottom_custom_text: @exports()
      bottom_bg: @exports()
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      opacity_header: true
      work_steps_show: @exports()
      result_show: @exports()
      work_steps: @state './work_steps'
      comments_landing: @exports()
      comments_img: @exports()
      comments_show: @exports()
      bg_position: @exports()
      result: @state './result'
      filter : @exports()
      value :
        phone : $urlform : pupil : 'phone'
        name  : $urlform : pupil : 'name'
      short_attach : @module 'short_form/js_form' :
        value : $urlform : pupil : ''
      tutors : $defer : =>
        @tree.content.filter ?= {}
        @tree.content.filter.page = 'landing'
        filter = yield Feel.udata.d2u "mainFilter",@tree.content.filter
        hash = yield Feel.udata.filterHash filter,'filter'
        filter = yield Feel.udata.u2d filter
        jobs = yield Main.service 'jobs'
        o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:6,from:0}
        o ?= {}
        o.preps ?= {}
        modules = for index,prep of o.preps
          @state './tutor_card':
            value:prep
            main_subject : _setKey @tree.content.filter,'subject.0'
        modules = yield Q.all modules
        return modules
      comments_landing: @state 'lp/comments_landing':
        comments: $defer : =>
          comments = yield Main.isomorph('lp/comments')
          comments = comments.getRandom 3
          return comments
