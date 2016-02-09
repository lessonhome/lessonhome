status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'



class @main
  DATA_FILTER = {}
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
    index = @tree.value?.index

    if index
      a.filter('a').off('click.prep').on 'click.prep', (e)=>
        return unless e.button == 0
        e.preventDefault()
        href = $(e.currentTarget).attr 'href'
        Q.spawn => Feel.main.showTutor index, href
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
  setFilter : (filter = {}) ->
    DATA_FILTER = {}
    if filter.metro?.length
      DATA_FILTER['metro'] = obj = {}
      for e in filter.metro
        e = e.split(':')[1]
        obj[e] = true

  getFilter : -> return DATA_FILTER
  setValue : (value)=>
    #Получение и обновление value
    value ?= @tree.value
    @tree.value = {}
    @tree.value[key] = val for key,val of value
    value = @tree.value
    filter = @getFilter()

    #Имя и отчество
    @found.name.text value.name
    #Аватарка и раздача ссылок
    @found.image.attr('src', value.photos)
    .attr('alt',value.name).attr('title',value.name)
    @dom.find('a').attr('href',value.link).attr('title',value.name)

    #Отзывы
    reviews = value.reviews
    if reviews != '0 отзывов'
      @prepareLink @found.review_a.show().attr('href', value.link_comment).find('span').text(reviews)
    else
      @found.review_a.hide()
    #Список предметов
    
    main_subject = main_subject || ""
    subjL = value.subject.length
    main_subject = main_subject.capitalizeFirstLetter()
    subjectID = 's' + value.index
    si = 0
    
    @found.subject.text ""
    @found.subject_block = $ '<span class="middle-span subject-text"><i class="material-icons">import_contacts</i></span>'
    @found.subject_list = $ '<span class="middle-span card-info-color"></span>'
    @found.subject.append @found.subject_block
    @found.subject_block.append @found.subject_list
        
    for line of value.subject
      if si != 0
        @found.subject_list.append ',&#32;' + value.subject[line]
      else
        @found.subject_list.append value.subject[line]
      si++


    #@found.subject.text value.subject

    #Опыт и статус преподавателя
    @found.experience.html '<i class="material-icons middle-icon">school</i><span class="middle-span">' +  value.experience + '</span>'

    @parseAbout true

    #Отображение города
    @found.location.html '<i class="material-icons">location_on</i><span class="middle-span card-info-color">' +  value.location + '</span>'

    #Отображение цены
    @found.price?.text? value.left_price

    #Метро
    @found.metro_line.html ''

    place = value.metro_tutors
    ###
    if filter.metro and place.type is 'metro' and place.data.length > 1
      _pl = []
      for p in place.data
        if filter.metro[p.key]?
          _pl.unshift(p)
        else
          _pl.push(p)

      place.data = _pl
    ###
    switch place.type
      when 'all', 'street', 'remote', 'area'
        @found.metro_line.append "<span class='middle-span card-info-color'>#{place.data}</span>"
      when 'metro'
        val = place.data[0]
        span = "
            <span class='stantion dropdown-button' data-hover='true' data-constrainwidth='false' data-activates='d#{value.index}'>"
        if val.color?
          span += "<i class='material-icons middle-icon' style='color:#{val.color}'>fiber_manual_record</i>"
        span +="<span class='card-info-color'>#{val.metro}</span>
          </span>"
        span = $ span

        @found.metro_line.append span

        if place.data.length > 1
          span.append("<div class='dotted_more-button right-align'></div>")
          ul = $("<ul class='dropdown-content' id='d#{value.index}'>")
          for val, i in place.data
            str = "
                <li>
                  <span class='stantion'>"
            if val.color
              str += "<i class='material-icons middle-icon' style='color:#{val.color}'>fiber_manual_record</i>"
            str += "<span>#{val.metro}</span>
                  </span>
                </li>
              "
            ul.append $ str
          @found.metro_line.append ul
          span.dropdown()


    yield @setLinked()


  parseAbout : (force = false)=>
    if !_isMobile.any()
      maxl = 500
    else
      maxl = 145
    tutor_text = @tree.value?.about ? ''
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

