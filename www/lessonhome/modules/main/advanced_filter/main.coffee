class @main extends EE
  Dom : =>
    @add_course_block  = @found.add_course_block
    @tag   = @found.tag
  show : =>
    # drop_down_list
    @list_course        = @tree.list_course.class
    # tag
    @add_course         = @tree.add_course.class
    # calendar
    @calendar           = @tree.calendar.class
    #slider
    @time_spend_lesson  = @tree.time_spend_lesson.class
    @time_spend_way     = @tree.time_spend_way.class
    # button
    @choose_gender      = @tree.choose_gender.class
    # checkbox
    @with_reviews       = @tree.choose_gender.class
    @with_verification  = @tree.choose_gender.class


    # action
    @list_course.on         'change',=> @emit 'change'
    # TODO: add_course hard code, not this module, only this file have this variables
    #@add_course.on          'change',=> @emit 'change'
    @calendar.on            'change',=> @emit 'change'
    @time_spend_lesson.on   'change',=> @emit 'change'
    @time_spend_way.on      'change',=> @emit 'change'
    @choose_gender.on       'change',=> @emit 'change'
    @with_reviews.on        'change',=> @emit 'change'
    @with_verification.on   'change',=> @emit 'change'

    @list_course.on         'and',=> @emit 'and'
    #@add_course.on          'and',=> @emit 'and'
    @calendar.on            'and',=> @emit 'and'
    @time_spend_lesson.on   'and',=> @emit 'and'
    @time_spend_way.on      'and',=> @emit 'and'
    @choose_gender.on       'and',=> @emit 'and'
    @with_reviews.on        'and',=> @emit 'and'
    @with_verification.on   'and',=> @emit 'and'

    @list_course.on 'end', => @addTag @getTags(), @add_course_block, @list_course.getValue()
    @list_course.on 'press_enter', => @addTag @getTags(), @add_course_block, @list_course.getValue()
    @closeHandler()


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
    )
    $(tags_div).append(new_tag)
  getTags: =>
    data = []
    children = $(@add_course_block).children()
    for child in children
      child = $ child
      data.push child.find(".text").text()
    console.log 'data : '+data, children
    return data
  closeHandler: =>
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
    else
      element.addClass('background').removeClass 'hover'
  change_visibility : (element)=>
    if element.is '.showed'
      element.removeClass 'showed'
    else
      element.addClass 'showed'


  getValue : => @getData()

  setValue : (data)=>
    @list_course.setValue       data.list_course        if data?.list_course?
    @add_course.setValue        data.add_course         if data?.add_course?
    @calendar.setValue          data.calendar           if data?.calendar?
    @time_spend_lesson.setValue data.time_spend_lesson  if data?.time_spend_lesson?
    @time_spend_way.setValue    data.time_spend_way     if data?.time_spend_way?
    @choose_gender.setValue     data.choose_gender      if data?.choose_gender?
    @with_reviews.setValue      data.with_reviews       if data?.with_reviews?
    @with_verification.setValue data.with_verification  if data?.with_verification?



  getData : =>
    return {
      list_course       : @list_course.getValue()
      add_course        : @add_course.getValue()
      calendar          : @calendar.getValue()
      time_spend_lesson : @time_spend_lesson.getValue()
      time_spend_way    : @day.getValue()
      choose_gender     : @choose_gender.getValue()
      with_reviews      : @with_reviews.getValue()
      with_verification : @with_verification.getValue()
    }


