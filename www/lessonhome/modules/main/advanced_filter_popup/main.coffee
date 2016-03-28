
class @main extends EE
  show : =>
    # gender button
    @female = @tree.female.class
    @male = @tree.male.class
    @female.on 'active', => @male.disable()
    @male.on 'active', => @female.disable()

    # change visibility show_hidden
    @sections = @dom.find '.section'
    for section in @sections
      section = $ section
      title  = section.find '.js-title'
      do (section)=>
       title.click => @change_visibility section

  change_visibility : (element)=>
    if element.hasClass 'showed'
      element.removeClass 'showed'
    else
      element.addClass 'showed'


  disable : =>
    if !@active then return
    @active = false
    @button.removeClass 'active'
    @button.addClass 'inactive'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button.removeClass 'inactive'
    @button.addClass 'active'
    @emit 'active'
