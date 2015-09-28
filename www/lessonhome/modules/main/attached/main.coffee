


class @main
  show : =>
    @found.bottom_bar.click @open
    @found.popup.click @close
  open : =>
    b = $('body')
    @scroll = b.scrollTop()
    b.css
      position  : 'fixed'
      top       : -@scroll
      width     : '100%'
    @found.content.addClass 'fixed'
    #@found.content.height @tree.popup.class.dom.height()
    #@tree.bottom_bar.class.absolute()
  close : =>
    b = $('body')
    b.css
      position : 'static'
    b.scrollTop @scroll
    @found.content.removeClass 'fixed'
    @tree.bottom_bar.class.fixed()