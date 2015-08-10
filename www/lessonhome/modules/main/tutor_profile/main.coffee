
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


