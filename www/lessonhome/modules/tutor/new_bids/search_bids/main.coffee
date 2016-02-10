class @main
  constructor: ->
    $W @
  show: =>
    bids = yield Feel.jobs.server 'getBids'
    for b in bids
      @dom.append("<a href='/tutor/bid_detail?#{yield Feel.udata.d2u 'tutorBids', {index: b._id}}'>#{b.time} #{b.name}</a><br>")
