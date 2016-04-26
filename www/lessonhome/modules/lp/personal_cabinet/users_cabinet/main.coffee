

class @main
  constructor : ->
    $W @
  show : =>
    for i,bid of @tree.bids
      bid.class.parent = @
      @activeBid = bid.class if bid.value.active

