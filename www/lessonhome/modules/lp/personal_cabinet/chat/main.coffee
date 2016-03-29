class @main
  constructor: ->
    $W @
  Dom : =>
    @chatBox = @found.chat_box

    @chatBox.niceScroll({
      cursorcolor: '#889395',
      cursorwidth: '7px',
      autohidemode: false
    })
