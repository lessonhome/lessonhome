
class @main extends EE
  show : =>
    @button = @dom.find ".button"
    @active = @button.hasClass 'active'
    @dom.on 'click', @click
  ###  disable : =>
    if !@active then return
    @active = false
    @button.removeClass 'active'
    @button.addClass 'inactive'
    @emit 'disable'
  able : =>
    if @active then return
    @active = true
    @button.removeClass 'inactive'
    @button.addClass 'active'
    @emit 'able'
  ###
  click : =>
    if @active
      @active = false
      @button.removeClass 'active'
      @button.addClass 'inactive'
    else
      @active = true
      @button.removeClass 'inactive'
      @button.addClass 'active'
    @emit 'active'
    ###
      return if @active
      @active = true
      @button.removeClass 'inactive'
      @button.addClass 'active'
      @emit 'active'
    ###



