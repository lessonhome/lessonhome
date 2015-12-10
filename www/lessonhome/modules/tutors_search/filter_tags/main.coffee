class @main
#  constructor: ->
#    $W @
  Dom: =>
    @tags = @found.tags_filter
  show : =>
    @tags.on 'click', 'i.close', -> console.log 'close'
  setValue: (value) ->
    console.log 'hello', value