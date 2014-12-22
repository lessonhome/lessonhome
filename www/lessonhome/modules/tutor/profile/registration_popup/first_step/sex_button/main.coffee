


class @main extends EventEmitter
  constructor : ->
    @active = false
  show : =>
    @button = @dom.find ".button"
    @active = @button.hasClass 'active'
    @dom.click @click
  disable : =>
    return unless @active
    @active = false
    @button.removeClass 'active'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button.addClass 'active'
    @emit 'active'
