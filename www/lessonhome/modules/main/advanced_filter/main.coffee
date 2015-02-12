
class @main extends EE
  show : =>
    # change visibility show_hidden
    @sections = @dom.find '.section'
    for section in @sections
      section = $ section
      title  = section.find '.js-title'
      do (section)=>
        title.click => @change_visibility section

    # gender button
    @female = @tree.female.class
    @male   = @tree.male.class
    @female.on 'active', @male.disable
    @male.on 'active', @female.disable

    #select experience
    @experience = @dom.find '.js-experience>div'
    for exp,i in @experience
      exp = $ exp
      do (exp,i)=>
        exp.click =>
          if i == (@experience.length-1)
             unless @experience.last().hasClass 'background'
              @experience.filter('.background').removeClass 'background'
              @experience.addClass 'hover'
          else
            @experience.last().removeClass 'background'
            @experience.last().addClass 'hover'
          @change_background exp



############## function ##############

  change_background : (element)=>
    if element.is '.background'
      element.removeClass('background').addClass 'hover'
    else
      element.addClass('background').removeClass 'hover'


  change_visibility : (element)=>
    if element.is '.showed'
      element.removeClass 'showed'
    else
      element.addClass 'showed'



