

global.SLAVEPROCESSMESSANGERID = 0

SlaveProcessConnector = require './slaveProcessConnector'

class SlaveProcessMessanger
  constructor : ->
    Wrap @
    @ee = new EE
    @queryEE = new EE
    @receive 'query',@onQuery
    @connectors = {}
  init : =>
    process.on 'message', @onMessage
    yield @setQuery()
  send      : (msg,args...)=>
    process.send {msg,args}
  receive   : => @ee.on arguments...
  onMessage : ({msg,args  })=>
    @ee.emit msg,args...
  query     : (args...)=> # query(name,args...)
    id = global.SLAVEPROCESSMESSANGERID++
    defer = Q.defer()
    @ee.once 'query:'+id, (err,data)=>
      return defer.reject ExceptionUnJson err if err?
      defer.resolve  data
    @send 'query',id,args...
    return defer.promise
  setQuery : =>
    @queryEE.__emit = @queryEE.emit
    @queryEE.emit   = (name,id,args...)=>
      if !@["q_"+name]?
        @queryEE.__emit "#{name}:#{id}", ExceptionJson new Error 'unknown query '+name+' to master process'
      else
        @["q_"+name](args...)
        .then (data)=>
          @queryEE.__emit "#{name}:#{id}",null,data
        .catch (err)=>
          @queryEE.__emit "#{name}:#{id}",ExceptionJson err
  onQuery : (id,name,args...)=>
    nid = "master:#{id}"
    @queryEE.once "#{name}:#{nid}",(err,data)=>
      @send "query:#{id}",err,data
    @queryEE.emit name,nid,args...
  q_connect : (conf)=>
    connector = new SlaveProcessConnector conf
    yield connector.init()
    @connectors[connector.id] = connector
    connector.data()
  q_connectorFunction : (id,name,args...)=>
    @connectors[id].qFunction name,args...
  q_connectorVarGet : (id,name)=>
    @connectors[id].qVarGet name
  q_connectorVarSet : (id,name,val)=>
    @connectors[id].qVarSet name,val
  q_connectorOn   : (id,action)=>
    @connectors[id].qOn action
  q_connectorEmit : (id,action,data...)=>
    @connectors[id].qEmit action,data...
   
module.exports = SlaveProcessMessanger
