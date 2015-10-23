
class @main extends EE
  Dom: =>
    @back = @found.back
    @about_content = @found.about_content
    @about = @found.about
    @subjects = @found.subjects
    @reviews = @found.reviews
    @about_content = @found.about_content
    @subjects_content = @found.subjects_content
    @reviews_content = @found.reviews_content
    @header_items = [@about, @subjects, @reviews]
    @contents = [@about_content, @subjects_content, @reviews_content]
    @full_name = @found.full_name
    @location = @found.location
    @description = @found.description
    @status = @found.status
    @experience = @found.experience
    @age = @found.age
    @work_place = @found.work_place
    @education = @found.education
    @areas_departure = @found.areas_departure
    @about_text = @found.about_text
    #@honors_text = @found.honors_text
    @rating_photo   = @tree.rating_photo.class
    @hidden_subject = @tree.hidden_subject.class
    @status_values = {"student":"Студент", "private_teacher":"Частный преподаватель", "university_teacher":"Преподаватель ВУЗа", "school_teacher":"Преподаватель школы"}
    @areas_departure_value = @found.areas_departure_value
    @write_button = @found.write_button
    @msg = @tree.msg.class
    @name =  @tree.name.class
    @phone = @tree.phone.class
    @subject = @tree.subject.class
    @agree_checkbox = @tree.agree_checkbox.class
    @write_tutor_error_field = @found.write_tutor_error_field
  show: => do Q.async =>
    yield @open()
    $(@back).click => @goBack()
    $(@about).on 'click', =>
      @setActiveItem @about, @about_content
      Feel.urlData.set('tutorProfile',{'inset':0})
    $(@subjects).on 'click', =>
      @setActiveItem @subjects, @subjects_content
      Feel.urlData.set('tutorProfile',{'inset':1})
    $(@reviews).on 'click', =>
      @setActiveItem @reviews, @reviews_content
      Feel.urlData.set('tutorProfile',{'inset':2})
    @agree_checkbox.on 'change', => @write_tutor_error_field.hide()
    $(@write_button).on 'click', => Q.spawn =>
      @found.right.css 'min-height','inherit'
      result = yield @save()
      if result
        @found.write_tutor_content.text("Ваше сообщение отправлено! Скоро с Вами свяжутся.")
    @found.attach_button.click @addTutor
    Feel.urlData.on 'change',=> @setLinked()
  open : (prep)=> do Q.async =>
    state = History.getState()
    unless ((""+document.referrer).indexOf document.location.href.substr(0,15))== 0
      $(@back).hide()
    else
      $(@back).show()
    unless prep?
      data = yield Feel.urlData.get('tutorProfile','inset')
      switch data
        when 0
          @setActiveItem @about, @about_content
        when 1
          @setActiveItem @subjects, @subjects_content
        when 2
          @setActiveItem @reviews, @reviews_content
      @index = yield Feel.urlData.get('tutorProfile','index') ? 77
      preps=yield Feel.dataM.getTutor [@index]
      prep = preps[@index]
    else
      @index = prep
      preps=yield Feel.dataM.getTutor [@index]
      prep = preps[@index]
    return unless prep?
    #return Feel.go '/second_step' unless prep?
    unless prep.reviews && prep.reviews.length
      @reviews.hide()
    @setValue prep
  goBack: =>
    if @tree.onepage
      return Feel.root.tree.class.hideTutor()
    #Feel.go '/second_step'
    if History.back()
      setInterval @goHitoryUrl,100
      @goHistoryUrl()
      return
    document.location.href = document.referrer
  goHistoryUrl : =>
    setTimeout ->
      document.location.href = History.getState().url
    ,0
  setActiveItem: (item, content)=>
    return if item.hasClass 'active'
    for val in @header_items
      if val.hasClass 'active'
        val.removeClass 'active'
    item.addClass 'active'
    for val in @contents
      val.hide()
    content.show()
  addTutor : => Q.spawn =>
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    if linked[@tree.value.index]?
      delete linked[@tree.value.index]
    else
      linked[@tree.value.index] = true
    yield Feel.urlData.set 'mainFilter','linked',linked
    @setLinked()
  setLinked : (linked)=> Q.spawn =>
    linked ?= yield Feel.urlData.get 'mainFilter','linked','reload'
    if linked[@tree.value.index]?
      @tree.attach_button?.class?.setValue {text:'прикрепить к заявке'}
      @tree.attach_button?.class?.setActiveCheckbox()
      #@hopacity.removeClass 'g-hopacity'
    else
      @tree.attach_button?.class?.setValue {text:'прикрепить к заявке'}
      @tree.attach_button?.class?.setDeactiveCheckbox()
      #@hopacity.addClass 'g-hopacity'
  setValue : (data={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of data
    @rating_photo.setValue {
      photos : data.photos
    }
    @tree.rating.class.setValue rating:data.rating
    if Feel.user?.type?.admin
      @found.full_name.text("#{data.name.last ? ""} #{data.name.first ? ""} #{data.name.middle ? ""}")
    else
      @found.full_name.text("#{data.name.first ? ""} #{data.name.middle ? ""}")
    l = data?.location ? {}
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
    ls1 = cA ls1,l.area
    if Feel.user?.type?.admin
      ls1 = cA ls1,data.login,'<br>'
      ls1 = cA ls1,data.phone?.join('; '),'<br>'
      ls1 = cA ls1,data.email?.join('; '),'<br>'
    ls3 = ""
    ls3 += "м. #{l.metro}" if l.metro
    ls = ""
    ls = cA ls,ls3,'<br>'
    ls = cA ls,ls1,'<br>'
    
    @found.location.html ls
    ###
    if data.location?.country
      if data.location?.city
        if data.location?.area
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""} р.#{data.location?.area ? ""}")
        else
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""}")
      else
        @found.location.text(data.location?.country ? "")
    else
      @found.location.hide()
    ###
    @setLinked()
    if data.slogan? && data.slogan
      @found.description.text(data.slogan)
      @found.description.show()
    @setItem @found.status, @status_values[data.status], @found.status_value
    @setItem @found.experience, data.experience, @found.experience_value
    if data.age? && data.age
      age_end = data.age%10
      switch age_end
        when 1
          @found.age_value.text(data.age+" год")
        when 2
          @found.age_value.text(data.age+" года")
        when 3
          @found.age_value.text(data.age+" года")
        when 4
          @found.age_value.text(data.age+" года")
        else
          @found.age_value.text(data.age+" лет")
    else
      @found.age.hide()
    #@setItem @found.age, data.age, @found.age_value
    last_work = data.work?[Object.keys(data.work ? {})?.pop?()]
    if last_work
      if last_work.place? && last_work.place
        #alert last_work.post?
        #alert last_work.post
        if last_work.post? && last_work.post
          @found.work_place_value.text(last_work.place, last_work.post)
        else
          @found.work_place_value.text(last_work.place)
      else
        @found.work_place.hide()
    else
      @found.work_place.hide()
    if data.education?[0]?.name
      if data.education?[0]?.faculty
        @found.education_value.text("#{data.education?[0]?.name ? ""}, #{data.education?[0]?.faculty ? ""}")
      else
        @found.education_value.text("#{data.education?[0]?.name ? ""}")
    else
      @found.education.hide()
    if data.check_out_the_areas?
      for key, val of data.check_out_the_areas
        if key > 0
          $(@areas_departure_value).append(", #{val}")
        else
          $(@areas_departure_value).append(val)
    else
      @areas_departure.hide()
    @found.about_text.text("#{data.about ? ""}")
    if data.interests?
      for key, val of data.interests
        if val.description
          if key > 0
            $(@found.interests_val).append(", #{val.description}")
            @found.interests.show()
          else
            $(@found.interests_val).append(val.description)
            @found.interests.show()
    if data.reason? && data.reason
      @found.reason_val.text(data.reason)
      @found.reason.show()
    #@honors_text.text("#{data.honors_text ? ""}")
    subjects_number = 0
    @tutor_subjects = []
    @subjects_content.empty()
    console.log data.subjects
    for key,val of data.subjects
      ss = key.split /[\.,;]/
      for s in ss
        s = s.replace /^\s+/,''
        s = s.replace /\s+$/,''
        if s.length > 2
          @tutor_subjects.push [s,val]
          subjects_number++
    newarr = []
    for s in @tutor_subjects
      new_subject = @hidden_subject.$clone()
      new_subject.setValue s[0], s[1], data.place
      newarr.push s[0]
      @subjects_content.append(new_subject.dom)
    @tutor_subjects = newarr
    console.log @tutor_subjects
    # right panel
    $(@found.write_tutor_msg).on 'click', =>
      @found.write_tutor_name.addClass 'shown'
      @found.write_tutor_phone.addClass 'shown'
      @found.write_tutor_subject.addClass 'shown'
    $(@write_button).on 'click', =>
      @found.write_tutor_name.addClass 'shown'
      @found.write_tutor_phone.addClass 'shown'
      @found.write_tutor_subject.addClass 'shown'
    dative_tutor_name = @dativeName data.name
    @found.write_tutor_title.text("Написать "+dative_tutor_name.first)
    @tree.write_button.class.setValue "Написать "+dative_tutor_name.first
    if subjects_number > 1
      @tree.subject.class.setItems @tutor_subjects
    else
      @tree.subject.class.setValue @tutor_subjects[0]
      @found.write_tutor_subject.hide()
    @dom.css 'opacity',1

  setItem: (item_block, item_value, value_block)=>
    if item_value
      value_block.text("#{item_value ? ""}")
    else
      item_block.hide()

  dativeName : (data)->
    name = _nameLib.get((data?.last ? ''),(data?.first ? ''),(data?.middle ? ''))
    return {
      first : name.firstName('dative')
      middle: name.middleName('dative')
      last  : name.lastName('dative')
    }

  save : => do Q.async =>
    return false unless @check_form()
    {status,errs} = yield @$send('../attached/save',@getData())
    if status=='success'
      Feel.sendActionOnce 'direct_bid'
      return true
    return false

  check_form : =>
    errs = @js.check @getData()
    for e in errs
      @parseError e
    return errs.length==0

  parseError : (err)=>
    switch err
    #short
      when "short_name"
        @name.showError "Слишком короткое имя "
      when "short_phone"
        @phone.showError "Неккорректный телефон"
    #empty
      when "empty_name"
        @name.showError "Введите имя"
      when "empty_phone"
        @phone.showError "Введите телефон"
      when "empty_subject"
        @subject.showError "Выберите предмет"
      #when "disagree_checkbox"
        #@write_tutor_error_field.text("Пожалуйста ознакомьтесь с пользовательским соглашением")
        #@write_tutor_error_field.show()

  getData : =>
    return {
      id:             @index
      comments:       @msg.getValue()
      name:           @name.getValue()
      phone:          @phone.getValue()
      subject:        @subject.getValue()
    }
