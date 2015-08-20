
class @main
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
    state = History.getState()
    unless ((""+document.referrer).indexOf document.location.href.substr(0,15))== 0
      $(@back).hide()
  show: => do Q.async =>
    inset = Feel.urlData.get('tutorProfile','inset')
    inset.then (data)=>
      switch data
        when 0
          @setActiveItem @about, @about_content
        when 1
          @setActiveItem @subjects, @subjects_content
        when 2
          @setActiveItem @reviews, @reviews_content
    index = yield Feel.urlData.get('tutorProfile','index') ? 77
    console.log index
    preps=yield Feel.dataM.getTutor [index]
    prep = preps[index]
    return unless prep?
    console.log prep
    @setValue prep
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
    $(@write_button).on 'click', =>
      @found.write_tutor_content.text("Ваше сообщение отправлено! Скоро с Вами свяжутся.")
    @found.attach_button.click @addTutor
  goBack: =>
    document.location.href = window.history.back()
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
    linked = yield Feel.urlData.get 'mainFilter','linked'
    if linked[@tree.value.index]?
      delete linked[@tree.value.index]
    else
      linked[@tree.value.index] = true
    @setLinked linked
    yield Feel.urlData.set 'mainFilter','linked',linked
  setLinked : (linked)=> Q.spawn =>
    linked ?= yield Feel.urlData.get 'mainFilter','linked'
    if linked[@tree.value.index]?
      @tree.attach_button?.class?.setValue {text:'убрать',color:'#FF7F00',pressed:true}
      @tree.attach_button?.class?.setActiveCheckbox()
      #@hopacity.removeClass 'g-hopacity'
    else
      @tree.attach_button?.class?.setValue {text:'выбрать'}
      #@hopacity.addClass 'g-hopacity'
  setValue : (data={})=>
    @tree.value[key] = val for key,val of data
    @rating_photo.setValue {
      photos : data.photos
    }
    @tree.rating.class.setValue data.rating
    @found.full_name.text("#{data.name.last ? ""} #{data.name.first ? ""} #{data.name.middle ? ""}")
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
    @setLinked()
    if data.slogan? && data.slogan
      @found.description.text(data.slogan)
      @found.description.show()
    @setItem @found.status, @status_values[data.status], @found.status_value
    @setItem @found.experience, data.experience, @found.experience_value
    if data.age? && data.age
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
    for key,val of data.subjects
      new_subject = @hidden_subject.$clone()
      new_subject.setValue key, val, data.place
      console.log new_subject.dom
      $(@subjects_content).append(new_subject.dom)
    @dom.find('>div').css 'opacity',1
  setItem: (item_block, item_value, value_block)=>
    if item_value
      value_block.text("#{item_value ? ""}")
    else
      item_block.hide()

