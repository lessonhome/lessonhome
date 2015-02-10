
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

    #chandge color in select checkbox
    @reviews = @dom.find ".with_reviews_text"
    @verification = @dom.find ".with_verification_text"
    @with_reviews = @tree.with_reviews.class
    @with_verification = @tree.with_verification.class
    @with_reviews.on 'active', =>
      @reviews.addClass 'color'
    @with_verification.on 'active', =>
      @verification.addClass 'color'
    @with_reviews.on 'inactive', =>
      @reviews.removeClass 'color'
    @with_verification.on 'inactive', =>
      @verification.removeClass 'color'

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


    #add time in day
    @button_add = @tree.button_add.class
    @button_add.on 'click', => @emit 'add_time'
    #TODO: ....



############## function ##############

  change_background : (element)=>
    if element.hasClass 'background'
      element.removeClass 'background'
      element.addClass 'hover'
    else
      element.addClass 'background'
      element.removeClass 'hover'


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
