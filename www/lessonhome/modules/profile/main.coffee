class @main
  Dom : =>
    @viewPhoto    = @found.view_photo
    @chooseTutor  = @found.tutor_trigger
    @triggerCount = 0

    #scroll spy
    @reviewMark   = @found.review_mark
  show: =>
    $(@viewPhoto).materialbox()
    @chooseTutor.on 'click', @showTrigger

    #scroll spy
    @reviewMark.scrollSpy()
  showTrigger : =>
    if @triggerCount == 0
      @chooseTutor.addClass('waves-light teal lighten-2 selected white-text').removeClass('btn-trigger waves-teal')
      @chooseTutor.find('.tutor_button_text').html('Убрать')
      @chooseTutor.find('.material-icons').html('remove')
      @triggerCount = 1
    else
      @chooseTutor.removeClass('waves-light teal lighten-2 selected white-text').addClass('btn-trigger waves-teal')
      @chooseTutor.find('.tutor_button_text').html('Выбрать')
      @chooseTutor.find('.material-icons').html('add')
      @triggerCount = 0

