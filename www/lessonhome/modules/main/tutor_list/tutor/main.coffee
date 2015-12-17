status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'



class @main
  constructor : -> $W @
  Dom: =>
    @chooseTutor      = @found.tutor_trigger
  show: =>
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=> Q.spawn => yield @setLinked()
  hide: =>
    
  onTutorChoose : =>
    active  = !@found.tutor_trigger.hasClass('selected')
    @tutorChoose      active
    yield @setLinked  active,false
  setLinked : (active,choose = true)=>
    return unless @tree.value?.index
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    state = active ? linked?[@tree.value.index]==true
    if active?
      unless state
        delete linked?[@tree.value.index]
      else
        linked?[@tree?.value?.index] = true
      yield Feel.urlData.set 'mainFilter','linked',linked
    @tutorChoose state==true if choose
  tutorChoose : (active)=>
    if active
      @found.tutor_trigger.addClass('waves-light teal lighten-2 selected white-text').removeClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Убрать')
      @found.tutor_trigger.find('.material-icons').html('remove')
    else
      @found.tutor_trigger.removeClass('waves-light teal lighten-2 selected white-text').addClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Выбрать')
      @found.tutor_trigger.find('.material-icons').html('add')
  setValue : (value)=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    value = @tree.value

    @found.name.text value.name

    @found.subject.text value.subject

    @found.experience.text value.experience

    isMobile =
      Android:    ->
        return navigator.userAgent.match(/Android/i)
      BlackBerry: ->
        return navigator.userAgent.match(/BlackBerry/i)
      iOS:        ->
        return navigator.userAgent.match(/iPhone|iPad|iPod/i)
      Opera:      ->
        return navigator.userAgent.match(/Opera Mini/i)
      Windows:    ->
        return navigator.userAgent.match(/IEMobile/i)
      any:        ->
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows())

    tutor_text = value.about

    if !isMobile.any()
      maxl = 500
    else
      maxl = 145

    if (tutor_text.length > maxl)
      tutor_text = tutor_text.substr 0,maxl-11
      tutor_text = tutor_text.replace /\s+[^\s]*$/gim,''
      tutor_text += '... '
      @found.about.text tutor_text
      @found.about.append $("<a class='about_link'>подробнее</a>")
    else
      @found.about.text tutor_text

    @found.location.html(value.location)

    @found.metro_line.html ''

    metro_obj = value.metro_tutors
    for line of metro_obj
      if (name in metro_obj[line]) == false
        @found.metro_line.append '<span class="stantion"><i class="material-icons ' + metro_obj[line].color  + '">directions_transit</i>' + metro_obj[line].metro + '</span>'

    console.log metro_obj

    @found.price?.text?(value.left_price)

    src_path = value.photos
    @found.image.attr('src', src_path)
      .attr('alt',value.name).attr('title',value.name)
    #link = '/tutor_profile?'+yield  Feel.udata.d2u 'tutorProfile',{index:value.index}
    @dom.find('a').attr('href',value.link).attr('title',value.name).attr('alt',value.name)
    @dom.find('a').click (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn =>
        Feel.main.showTutor @tree.value.index,link
      return false
      

    
    yield @setLinked()
