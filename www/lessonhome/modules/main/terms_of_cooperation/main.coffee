


class @main
  constructor : ->
    Wrap @
    window.popup = @
  show : =>
    @found.link.click =>
      @hide()
      return false
    @found.background.click =>
      @hide()
      return false

  open : =>
    b = $('body')
    @scroll = b.scrollTop()
    b.css
      position  : 'fixed'
      top       : -@scroll
      width     : '100%'
    @dom.show()
    
  hide : =>
    b = $('body')
    b.css
      position : 'static'
    b.scrollTop @scroll
    @dom.hide()

