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
    Feel.dataM.getTutor([@tree.value.index]).done() if @tree.value?.index
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=> Q.spawn => yield @setLinked()
    @parseAbout()
    @prepareLink @dom.find('a')
    yield @setLinked()

  prepareLink : (a)=>
    index = @tree.value.index
    a.filter('a').off('click.prep').on 'click.prep', (e)->
      return unless e.button == 0
      e.preventDefault()
      Feel.main.showTutor index,$(this).attr 'href'
      return false

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
      @found.tutor_trigger.addClass('waves-light orange-btn selected white-text').removeClass('btn-trigger waves-grey')
      @found.tutor_trigger.find('.tutor_button_text').html('Убрать')
      @found.tutor_trigger.find('.material-icons').html('remove')
    else
      @found.tutor_trigger.removeClass('waves-light orange-btn selected white-text').addClass('btn-trigger waves-grey')
      @found.tutor_trigger.find('.tutor_button_text').html('Выбрать')
      @found.tutor_trigger.find('.material-icons').html('add')
  setValue : (value)=>
    #Получение и обновление value
    value ?= @tree.value
    @tree.value = {}
    @tree.value[key] = val for key,val of value
    value = @tree.value

    #Имя и отчество
    @found.name.text value.name
    
    #Список предметов
    
    main_subject = main_subject || ""
    subjL = value.subject.length
    main_subject = main_subject.capitalizeFirstLetter()
    subjectID = 's' + value.index
    si = 0
    @found.subject.text ""

    if(main_subject != "")
      @found.subject.append '<span class="stantion"><i class="material-icons">import_contacts</i><span class="middle-span subject-color">' + main_subject + '</span></span>'
    else
      if(subjL == 1)
        for line of value.subject
          @found.subject.append '<span class="stantion"><i class="material-icons">import_contacts</i><span class="middle-span subject-color">' + value.subject[line] + '</span></span>'
      else
        for line of value.subject
          sdd_button = $ '<span class="dropdown-button stantion" data-hover="true" data-alignment="right" data-beloworigin="true" data-constrainwidth="false" data-activates="' + subjectID  + '"></span>'
          sdd_button.append '<i class="material-icons">import_contacts</i><span class="middle-span subject-color">' + value.subject[line]  + '</span><div class="dotted_more-button right-align"></div>'
          @found.subject.append sdd_button
          break
        @found.subject_ul = $ '<ul id="' + subjectID  + '" class="dropdown-content"></ul>'
        @found.subject.append @found.subject_ul
        for line of value.subject
          if(si++==0)
            continue
          @found.subject_ul.append '<li><span class="stantion"><i class="material-icons">import_contacts</i><span class="middle-span">' + value.subject[line]  + '</span></span></li>'
        sdd_button.dropdown()

    #@found.subject.text value.subject

    #Опыт и статус преподавателя
    @found.experience.html '<i class="material-icons middle-icon">school</i><span class="middle-span">' +  value.experience + '</span>'

    @parseAbout true

    #Отображение города
    @found.location.html '<i class="material-icons">location_on</i><span class="middle-span card-info-color">' +  value.location + '</span>'

    #Отображение цены
    @found.price?.text? value.left_price

    #Аватарка и раздача ссылок
    @found.image.attr('src', value.photos)
      .attr('alt',value.name).attr('title',value.name)
    @dom.find('a').attr('href',value.link).attr('title',value.name).attr('alt',value.name)

    #Метро
    @found.metro_line.html ''

    metro_obj = value.metro_tutors
    metroL = Object.keys(metro_obj).length
    ti = 0
    metroID = 'd' + value.index
    
    if(metroL == 1)
      for line of metro_obj
        @found.metro_line.append '<span class="stantion"><i class="' + metro_obj[line].color  + ' material-icons middle-icon">fiber_manual_record</i><span class="card-info-color">' + metro_obj[line].metro  + '</span></span>'
    else if(metroL == 0)
      street_loc = value.street_loc || value.area_loc || ""
      if(street_loc != "")
        @found.metro_line.append '<span class="middle-span card-info-color">' + street_loc  + '</span>'
    else
      for line of metro_obj
        dd_button = $ '<span class="dropdown-button stantion" data-hover="true" data-alignment="right" data-beloworigin="true" data-constrainwidth="false" data-activates="' + metroID  + '"></span>'
        dd_button.append '<i class="' + metro_obj[line].color  + ' material-icons middle-icon">fiber_manual_record</i><span class="card-info-color">' + metro_obj[line].metro  + '</span><div class="dotted_more-button right-align"></div>'
        @found.metro_line.append dd_button
        break
      @found.metro_ul = $ '<ul id="' + metroID  + '" class="dropdown-content"></ul>'
      @found.metro_line.append @found.metro_ul
      for line of metro_obj
        if(ti++==0)
          continue
        @found.metro_ul.append '<li><span class="stantion"><i class="' + metro_obj[line].color  + ' material-icons middle-icon">fiber_manual_record</i><span>' + metro_obj[line].metro + '</span></span></li>'
      dd_button.dropdown()

    yield @setLinked()


  parseAbout : (force = false)=>
    if !_isMobile.any()
      maxl = 500
    else
      maxl = 145
    tutor_text = @tree.value.about
    if (tutor_text.length > maxl)
      tutor_text = tutor_text.substr 0,maxl-11
      tutor_text = tutor_text.replace /\s+[^\s]*$/gim,''
      tutor_text += '... '
      @found.about.text tutor_text
      la = $("<a class='about_link' href='#{@found.name.attr('href')}'>подробнее</a>")
      @found.about.append la
      @prepareLink la
    else if force
      @found.about.text tutor_text

