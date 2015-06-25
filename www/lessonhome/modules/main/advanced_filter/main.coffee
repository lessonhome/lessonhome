class @main extends EE
  Dom : =>
    @subject_reset       = @found.subject_reset
    @tutor_status_reset  = @found.tutor_status_reset
    @place_reset         = @found.place_reset
    @course_reset        = @found.course_reset
    @group_lessons_reset = @found.group_lessons_reset
    @experience_reset    = @found.experience_reset
    @sex_reset           = @found.sex_reset
    @price_reset         = @found.price_reset
    @time_to_way_reset   = @found.time_to_way_reset
  show : =>
    # drop_down_list
    @subject            = @tree.subject.class
    @area               = @tree.area.class
    @course             = @tree.course.class
    @group_lessons     = @tree.group_lessons.class
    # calendar
    @calendar           = @tree.calendar.class
    #slider
    @price              = @tree.price.class
    @time_spend_way     = @tree.time_spend_way.class
    # button
    @choose_gender      = @tree.choose_gender.class
    # checkbox
    @student            = @tree.student.class
    @school_teacher     = @tree.school_teacher.class
    @university_teacher = @tree.university_teacher.class
    @private_teacher    = @tree.private_teacher.class
    @native_speaker     = @tree.native_speaker.class
    @pupil              = @tree.pupil.class
    @tutor              = @tree.tutor.class
    @remote             = @tree.remote.class
    @little_experience  = @tree.little_experience.class
    @big_experience     = @tree.big_experience.class
    @bigger_experience  = @tree.bigger_experience.class
    @no_experience      = @tree.no_experience.class

    @with_reviews       = @tree.with_reviews.class
    @with_verification  = @tree.with_verification.class
    # other
    @choose_gender      = @tree.choose_gender.class

    # action
    # TODO: add_course hard code, not this module, only this file have this variables

    @on 'change', => Q.spawn =>
      v = @getValue()
      for key,val of v
        yield Feel.urlData.Short key,val
      console.log v
      ###
      data = {}
      state = History.getState()
      console.log 'state',state
      data.title = state.title
      unless data.title
        data.title = $('head>title').text()
      data.obj = {}
      data.obj[key] = val for key,val of state.data
      data.bson   = state.url.match /\?(.*)/
      if data.bson
        data.bson = data.bson[1].split '&'
        arr = {}
        for a in data.bson
          a = a.split '='
          arr[a[0]] = a[1]
        data.bson = arr
      data.bson ?= {}
      v = @getValue()
      bson = _objToBson v,'leftFilter'
      console.log bson
      data.obj['leftFilter'] = v
      for key,val of bson
        data.bson[key] = val
      data.bson = _objToUrlString data.bson
      console.log 'data',data
      History.pushState data.obj,data.title,state.url.match(/^([^\?]*)/)[1]+"?#{data.bson}"
      ###
    #@on 'end', => console.log @getValue()

    @calendar.on            'change',=> @emit 'change'
    @price.on               'change',=> @emit 'change'
    @time_spend_way.on      'change',=> @emit 'change'
    @choose_gender.on       'change',=> @emit 'change'
    @with_reviews.on        'change',=> @emit 'change'
    @with_verification.on   'change',=> @emit 'change'

    @calendar.on            'end',=> @emit 'end'
    @price.on               'end',=> @emit 'end'
    @time_spend_way.on      'end',=> @emit 'end'
    @choose_gender.on       'end',=> @emit 'end'
    @with_reviews.on        'end',=> @emit 'end'
    @with_verification.on   'end',=> @emit 'end'

    # change visibility show_hidden
    @sections = @found.section
    for section in @sections
      section = $ section
      do (section)=>
        title = section.find(">.title")
        title.click => @change_visibility section

    #select experience
    @experience = @found.experience.children()
    for exp,i in @experience
      exp = $ exp
      do (exp,i)=>
        exp.click =>
          if i == (@experience.length-1)
             unless @experience.last().hasClass 'background'
              @experience.filter('.background').removeClass 'background'
              @experience.addClass 'hover'
          else
            @experience.last().removeClass 'background'
            @experience.last().addClass 'hover'
          @change_background exp

    # reset forms
    $(@subject_reset).on 'click', => @subject.reset()
    $(@tutor_status_reset).on 'click', =>
      @student.setValue false
      @school_teacher.setValue false
      @university_teacher.setValue false
      @private_teacher.setValue false
      @native_speaker .setValue false
    $(@place_reset).on 'click', =>
      @pupil.setValue false
      @tutor.setValue false
      @remote.setValue false
      @area.reset()
    $(@sex_reset).on 'click', => @choose_gender.reset()
    $(@experience_reset).on 'click', =>
      @little_experience.setValue false
      @big_experience.setValue false
      @bigger_experience.setValue false
      @no_experience.setValue false
    $(@course_reset).on 'click', => @course.reset()
    $(@group_lessons_reset).on 'click', => @group_lessons.setValue ''
    $(@price_reset).on 'click', => @price.reset()
    $(@time_to_way_reset).on 'click', => @time_spend_way.reset()

    #alert @price.getMoveBlock().width()

  change_background : (element)=>
    if element.is '.background'
      element.removeClass('background').addClass 'hover'
      @emit 'change'
      @emit 'end'
    else
      element.addClass('background').removeClass 'hover'
      @emit 'change'
      @emit 'end'
  change_visibility : (element)=>
    if element.is '.showed'
      element.removeClass 'showed'
    else
      element.addClass 'showed'


  getValue : => @getData()

  setValue : (data)=>
    #@add_course.setValue        data.add_course         if data?.add_course?
    @calendar.setValue          data.calendar           if data?.calendar?
    @time_spend_lesson.setValue data.time_spend_lesson  if data?.time_spend_lesson?
    @time_spend_way.setValue    data.time_spend_way     if data?.time_spend_way?
    #@choose_gender.setValue     data.choose_gender      if data?.choose_gender?
    @with_reviews.setValue      data.with_reviews       if data?.with_reviews?
    @with_verification.setValue data.with_verification  if data?.with_verification?


  getData : =>
    experience = []
    for child in @experience
      if $(child).hasClass("background") then experience.push $(child).find(".text").text()

    return {
      subject           : @subject.getValue()
      price             : @price.getValue()
      time_spend_way    : @time_spend_way.getValue()
      experience        : experience
      choose_gender     : @choose_gender.getValue()
      with_reviews      : @with_reviews.getValue()
      with_verification : @with_verification.getValue()
    }


