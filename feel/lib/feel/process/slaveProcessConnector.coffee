

class SlaveProcessConnector
  constructor : (@__conf)->
    Wrap @
  __init : =>
    data = yield Main.messanger.query('nearest')
    console.log 'data',data


module.exports = SlaveProcessConnector


