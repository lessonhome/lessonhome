class @main extends EE
  Dom : =>
    @add_course_block  = @found.add_course_block
    @tag   = @found.tag
  show : =>
    # drop_down_list
    @list_course        = @tree.list_course.class
    # tag
    @add_course         = @tree.add_course
    # calendar
    @calendar           = @tree.calendar.class
    #slider
    @time_spend_lesson  = @tree.time_spend_lesson.class
    @time_spend_way     = @tree.time_spend_way.class
    # button
    @choose_gender      = @tree.choose_gender.class
    # checkbox
    @with_reviews       = @tree.with_reviews.class
    @with_verification  = @tree.with_verification.class

    # action
    # TODO: add_course hard code, not this module, only this file have this variables

    @on 'change', => console.log @getValue()
    @on 'end', => console.log @getValue()

    @calendar.on            'change',=> @emit 'change'
    @time_spend_lesson.on   'change',=> @emit 'change'
    @time_spend_way.on      'change',=> @emit 'change'
    @choose_gender.on       'change',=> @emit 'change'
    @with_reviews.on        'change',=> @emit 'change'
    @with_verification.on   'change',=> @emit 'change'

    @calendar.on            'end',=> @emit 'end'
    @time_spend_lesson.on   'end',=> @emit 'end'
    @time_spend_way.on      'end',=> @emit 'end'
    @choose_gender.on       'end',=> @emit 'end'
    @with_reviews.on        'end',=> @emit 'end'
    @with_verification.on   'end',=> @emit 'end'

    @list_course.on 'end', => @addTag @getTags(), @add_course_block, @list_course.getValue()
    @list_course.on 'press_enter', => @addTag @getTags(), @add_course_block, @list_course.getValue()
    @closeHendler()


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


############## function ##############
  addTag: (tags_arr, tags_div, tag_text)=>
    return if !tag_text
    @list_course.setValue('')
    if tags_arr.length
      for val in tags_arr
        if tag_text == val then return 0
    new_tag = $(@tag).clone()
    new_tag.find(".text").text(tag_text)
    new_tag.find(".close_box").click( =>
      new_tag.remove()
      @emit 'change'
      @emit 'end'
    )
    $(tags_div).append(new_tag)
    @emit 'change'
    @emit 'end'
  getTags: =>
    data = []
    children = $(@add_course_block).children()
    for child in children
      child = $ child
      data.push child.find(".text").text()
    console.log 'data : '+data, children
    return data
  closeHendler: =>
    children = $(@add_course_block).children()
    for child in children
      do (child)=>
        child = $ child
        child.find(".close_box").click( =>
          child.remove()
        )


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
    add_course_tags = []
    add_course_children = @add_course_block.children()
    for child in add_course_children
      tag = {}
      tag.text = $(child).find(".text").text()
      add_course_tags.push tag
    experience = []
    for child in @experience
      if $(child).hasClass("background") then experience.push $(child).find(".text").text()

    return {
      add_course_tags   : add_course_tags
      calendar          : @calendar.getValue()
      time_spend_lesson : @time_spend_lesson.getValue()
      time_spend_way    : @time_spend_way.getValue()
      experience        : experience
      choose_gender     : @choose_gender.getValue()
      with_reviews      : @with_reviews.getValue()
      with_verification : @with_verification.getValue()
    }


