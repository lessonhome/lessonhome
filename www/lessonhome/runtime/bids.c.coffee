




class Bids
  constructor : ->
    Wrap @
  init : =>
    return _waitFor @,'inited' if @inited == 1
    return if @inited > 1
    @inited = 1

    @bidsDb = yield @$db.get 'bids'

    yield @reload()

    @inited = 2
    @emit 'inited'
    setInterval =>
      @reload().done()
    , 1000*30

  handler : ($)=>
    yield @init() unless @inited == 2

  reload : =>
    bids = _invoke @bidsDb.find({}), 'toArray'

    [bids] = yield Q.all [bids]
    console.log {bids}

bids = new Bids

module.exports = bids




