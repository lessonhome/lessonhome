class @main
  Dom: =>
    @chooseTutor      = @found.tutor_trigger
  show: =>
    @chooseTutor.on 'click.tutor', @tutorChoose
  hide: =>
    @chooseTutor.off 'click.tutor', @tutorChoose

  tutorChoose : (e) =>
    e = e || window.event
    thisElement = $(e.currentTarget)
    thisSelect  = thisElement.hasClass('selected')

    if thisSelect == false
      thisElement.addClass('waves-light teal lighten-2 selected white-text').removeClass('btn-trigger waves-teal')
      thisElement.find('.tutor_button_text').html('Убрать')
      thisElement.find('.material-icons').html('remove')
    else
      thisElement.removeClass('waves-light teal lighten-2 selected white-text').addClass('btn-trigger waves-teal')
      thisElement.find('.tutor_button_text').html('Выбрать')
      thisElement.find('.material-icons').html('add')