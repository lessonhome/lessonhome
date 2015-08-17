
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

  show: =>
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
  setValue : (value)=>
    # TODO: photo
    @full_name.text("#{value.name.last ? ""} #{value.name.first ? ""} #{value.name.middle ? ""}")
    @location.text("#{value.location.country ? ""} #{value.location.city ? ""} #{value.location.area ? ""}")
    @description.text("#{value.about ? ""}")
    @status.text("#{value.status ? ""}")
    @experience.text("#{value.experience ? ""}")
    @age.text("#{value.age ? ""}")
    @work.text("#{value.work.name ? ""}")
    # TODO: education
    # TODO: areas