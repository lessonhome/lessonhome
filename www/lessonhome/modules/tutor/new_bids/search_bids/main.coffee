class @main
  constructor: ->
    $W @
  show: =>
    @dom.on 'click', 'a', (e) ->
      Q.spawn ->
        t = $(e.currentTarget).attr('href')
        console.log yield Feel.jobs.server('getDetailBid', t)
      return false
    bids = yield Feel.jobs.server 'getBids'
    for b in bids
      @dom.append("<a href='#{b._id}'>#{b.time} #{b.name}</a><br>")
