
class @main extends EE
  show : =>
    @slider = @dom.find ".slider"
    @cursorLeft = @slider.children().first()
    @cursorRight = @cursorLeft.next()

    #@cursorLeft.mousedown() => emit 'cursorLeft'
    #@cursorRight.mousedown() => emit 'cursorRight'
    @cursorLeft.on 'mousedown', @changePosition
    @cursorRight.on 'mousedown', @changePosition




  changePosition : =>
    console.log 'hello'