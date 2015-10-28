class @main
  Dom : =>
    @viewPhoto    = @found.view_photo
    @chooseTutor  = @found.tutor_trigger
    @tabsList     = @found.profile_tabs
    @triggerCount = 0
  show: =>
    $(@viewPhoto).materialbox()
    $(@tabsList).tabs()
    console.log @tabsList
    @chooseTutor.on 'click', @showTrigger
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

