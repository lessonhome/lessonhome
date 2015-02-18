

global.SLAVEPROCESSMESSANGERID = 0

class SlaveProcessMessanger
  constructor : ->
    Wrap @
    @ee = new EE
  init : =>
    process.on 'message', @onMessage
  send      : (msg,args...)=>
    process.send {msg,args}
  receive   : => @ee.on arguments...
  onMessage : ({msg,args  })=>
    @ee.emit msg,args...
  query     : ( args...)=> # query(name,args...)
    id = global.SLAVEPROCESSMESSANGERID++
    defer = Q.defer()
    @ee.once 'query:'+id, (err,data)=>
      defer.reject   err   if err?
      defer.resolve  data
    @send 'query',id,args...
    return defer.promise

module.exports = SlaveProcessMessanger
