
class @main extends EE
  Dom : =>
    @_active = true
    @link         = @dom.find "a"
    @link.on     'mousedown', @mdown
    @link.click (e)=>
      return unless e.button == 0
      e.preventDefault()
      return @submit() unless (e.button==0) && (!@tree.active)
      @emit('submit') if @_active
  show : =>


  mdown : =>
    if @link.hasClass 'active'
      @link.addClass('press')
      $('body').on 'mouseup.link_button', @mup
      $('body').on 'mouseleave.link_button', @mup

  mup   : =>
    if @link.hasClass 'active'
      $('body').off 'mouseup.link_button'
      $('body').off 'mouseleave.link_button'
      @link.removeClass 'press'
  submit : (href)=>
    href ?= @link.attr 'href'
    Feel.go href
  activate : (href)=>
    @tree.active = true
    @link.attr('href',href)

  active: => @_active = true
  deactive: =>@_active = false

  makeActive : =>
    return if @link.hasClass 'active'
    @link.removeClass 'inactive'
    @link.addClass 'active'

  makeInactive : =>
    return if @link.hasClass 'inactive'
    @link.removeClass 'active'
    @link.addClass 'inactive'

  setValue: (data)=>
    @found.text.text(data)
