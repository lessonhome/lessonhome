
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
  show: => do Q.async =>
    index = yield Feel.urlData.get('tutorProfile','index') ? 77
    console.log index
    preps=yield Feel.dataM.getTutor [index]
    prep = preps[index]
    return unless prep?
    console.log prep
    @setValue prep
    $(@back).click => @goBack()
    $(@about).on 'click', => @setActiveItem @about, @about_content
    $(@subjects).on 'click', => @setActiveItem @subjects, @subjects_content
    $(@reviews).on 'click', => @setActiveItem @reviews, @reviews_content
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
  setValue : (data={})=>
    @rating_photo.setValue {
      photos : data.photos
    }
    @tree.value.rating.class.setValue data.rating
    @found.full_name.text("#{data.name.last ? ""} #{data.name.first ? ""} #{data.name.middle ? ""}")
    @found.location.text("#{data.location?.country ? ""} #{data.location?.city ? ""} #{data.location?.area ? ""}")
    @found.description.text("#{data.slogan ? ""}")
    @found.status.text("#{data.status ? ""}")
    @found.experience.text("#{data.experience ? ""}")
    @found.age.text("#{data.age ? ""}")
    @found.work_place.text("#{data.work?.name ? ""}")
    @found.education.text("#{data.education?.name ? ""}")
    # TODO: areas
    @found.about_text.text("#{data.about ? ""}")
    #@honors_text.text("#{data.honors_text ? ""}")
    for key,val of data.subjects
      new_subject = @hidden_subject.$clone()
      new_subject.setValue key, val
      console.log new_subject.dom
      $(@subjects_content).append(new_subject.dom)

