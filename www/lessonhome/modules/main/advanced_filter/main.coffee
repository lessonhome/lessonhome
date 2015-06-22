class @main extends EE
  show : =>
    # drop_down_list
    @subject            = @tree.subject.class
    # calendar
    @calendar           = @tree.calendar.class
    #slider
    @price              = @tree.price.class
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
      calendar          : @calendar.getValue()
      price             : @price.getValue()
      time_spend_way    : @time_spend_way.getValue()
      experience        : experience
      choose_gender     : @choose_gender.getValue()
      with_reviews      : @with_reviews.getValue()
      with_verification : @with_verification.getValue()
    }


