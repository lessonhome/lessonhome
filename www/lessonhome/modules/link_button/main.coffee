
class @main extends EE
  Dom : =>
    @link         = @dom.find "a"
    @link.on     'mousedown', @mdown
    @link.click (e)=>
      return unless (e.button==0) && (!@tree.active)
      e.preventDefault()
      @emit 'submit'
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
  submit : =>
    href = @link.attr 'href'
    Feel.go href

  makeActive : =>
    return if @link.hasClass 'active'
    @link.removeClass 'inactive'
    @link.addClass 'active'

  makeInactive : =>
    return if @link.hasClass 'inactive'
    @link.removeClass 'active'
    @link.addClass 'inactive'
