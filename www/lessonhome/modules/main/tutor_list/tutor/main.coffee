class @main
  Dom: =>
    @tutorMore      = @found.tutor_more
  show: =>
    @tutorMore.on 'click.tutor', @moreTutor
  hide: =>
    @tutorMore.off 'click.tutor', @moreTutor

  moreTutor : (e) =>
    console.log('tro lo lo')