class @main
  constructor: ->
    $W @
  show: =>
    console.log yield Feel.jobs.server 'getBids'