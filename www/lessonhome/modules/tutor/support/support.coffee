class @main
  Dom : =>
    @show_block = @found.show
    @general    = @found.general
    @students   = @found.students
    @tutors     = @found.tutors
    @questions  = @found.questions

  show: =>
    for val in $(@show_block)
      do (val)=>
        val = $ val
        val.on 'click', => val.parent().toggleClass('showed')

    $(@general).on 'click', =>
      @questions.find('.general').show()
      @questions.find('.students').hide()
      @questions.find('.tutors').hide()
      @setActive @general
      @setInactive @students
      @setInactive @tutors

    $(@students).on 'click', =>
      @questions.find('.students').show()
      @questions.find('.general').hide()
      @questions.find('.tutors').hide()
      @setActive @students
      @setInactive @general
      @setInactive @tutors

    $(@tutors).on 'click', =>
      @questions.find('.tutors').show()
      @questions.find('.general').hide()
      @questions.find('.students').hide()
      @setActive @tutors
      @setInactive @general
      @setInactive @students

  setActive: (div)=>
    return if div.hasClass 'active'
    div.addClass 'active'
    return 0

  setInactive: (div)=>
    return if !div.hasClass 'active'
    div.removeClass 'active'
    return 0