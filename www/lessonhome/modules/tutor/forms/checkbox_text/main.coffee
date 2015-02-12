

class @main extends EE
  show : =>
    Feel.Hovered @
    @checkBox = @tree.checkBox.class
    @on 'hover', (hover)=> @checkBox.emit 'hover', hover
    @dom.click => @emit 'click'
    @on 'click', => @checkBox.emit 'click'