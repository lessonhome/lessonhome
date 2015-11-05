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
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    value = @tree.value
  
    name = "#{value?.name?.first ? ""} #{value?.name?.middle ? ""}"
    subject = ""
    for key of value.subjects
      subject += ', ' if subject
      subject += key?.capitalizeFirstLetter?()
    @found.subject.text subject
    
    exp = value.experience ? ""
    exp += " года" if exp && !exp?.match? /\s/
    @found.experience.text "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"

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

    tutor_text = value.about || ''
#    maxl = 500

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
  
    l = value?.location ? {}
    cA = (str="",val,rep=', ')->
      return str unless val
      val = ""+val
      val = val.replace /^\s+/,''
      val = val.replace /\s+$/,''
      return str unless val
      unless str
        str += val
      else
        str += rep+val

    ls1 = ""
    ls1 = cA ls1,l.city
#    ls1 = cA ls1,l.area
    ls2 = ""
    ls2 = cA ls2,l.street
    ls2 = cA ls2,l.house
    ls2 = cA ls2,l.building
    ls3 = ""
    ls3 += "м. #{l.metro}" if l.metro
    ls = ""
#    ls = cA ls,ls2,'<br>'
    ls = cA ls,ls3,'<br><br>'
    ls = cA ls,ls1,'<br>'
    @found.location.html(ls)
    
    @found.price?.text?(value.left_price)
     
    @found.name.text name
    rating = (value.rating-3)*3/2+4
    rating = Math.ceil(rating*10)/10
    stars = @found.stars.find('i')
    i = 0
    while i<=(rating)
      unless stars[i]
        star = $(stars[0]).clone(true,true)
        @found.stars.append star

      else
        star = $ stars[i]
      star.addClass 'orange-text'
      i++
    if rating <= 5
      rtext = 'Рейтинг: '+rating
    else if rating <= 6
      rtext = "Рейтинг: 5+"
    else
      rtext = "Рейтинг: 5++"
    if rating > 5
      @found.stars.find('i').css 'font-size':'1.2rem'
        

    @found.stars.attr('title',rtext).attr('alt',rtext)

    @found.image.attr('src', value.photos[value.photos.length-1].lurl)
      .attr('alt',name).attr('title',name)
    link = '/tutor_profile?'+yield  Feel.udata.d2u 'tutorProfile',{index:value.index}
    @dom.find('a').attr('href',link).attr('title',name).attr('alt',name)
    @dom.find('a').click (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn =>
        Feel.main.showTutor @tree.value.index,link
      return false
      

    
    yield @setLinked()
