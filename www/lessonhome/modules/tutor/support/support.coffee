class @main
  Dom : =>
    @show_block   = @found.show
    @sections     = @found.sections
    @general      = @found.general
    @registration = @found.registration
    @profile      = @found.profile
    @find_tutor   = @found.find_tutor
    @lessons      = @found.lessons
    @questions    = @found.questions
    @sections_tutor = {"general": @general, "registration": @registration , "profile": @profile}
    @sections_pupil = {"general": @general,"find_tutor": @find_tutor, "lessons":@lessons}
  show: =>
    for val in $(@show_block)
      do (val)=>
        val = $ val
        val.on 'click', => val.parent().toggleClass('showed')
    if @tree.selector == 'tutor_profile' || @tree.selector == 'tutor_support'
      @sectionsHandle @sections_tutor # handle of toggle between sections
    if  @tree.selector == 'pupil'
      @sectionsHandle @sections_pupil

  setActive: (div)=>
    return if div.hasClass 'active'
    div.addClass 'active'
    return 0

  setInactive: (div)=>
    return if !div.hasClass 'active'
    div.removeClass 'active'
    return 0

  sectionsHandle:(sections) =>
    for key, val of sections
      do (key, val)=>
        val = $ val
        val.on 'click', =>
          for k, v of sections
            do(k,v,key)=>
              if k != key
                class_str = ".#{k}"
                @questions.find(class_str).hide()
                @setInactive v
          class_str = ".#{key}"
          @questions.find(class_str).show()
          @setActive val

