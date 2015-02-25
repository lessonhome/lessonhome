
blackList = require './blackList'

class SlaveProcessConnect
  constructor : (@__conf)->
    @__conf = type:@__conf if typeof @__conf == 'string'
    @__conf.processId = Main.conf.processId
    Wrap @
  __init : =>
    @__data = yield Main.messanger.query 'connect',@__conf
    for func in @__data.functions
      continue if blackList func
      do (func)=>
        @[func] = (args...)=> @__function func,args...
    for name in @__data.vars
      continue if blackList name
      do (name)=>
        @[name]='UNDEFINED'
        Object.defineProperty @,name,
          get :     => @__get name
          set :(val)=> @__set name,val
    @on   = @__on
    @emit = @__emit
  __function : (name,args...)=>
    Main.messanger.query 'connectorFunction',@__data.id,name,args...
  __get : (name)=>
    Main.messanger.query 'connectorVarGet',@__data.id,name
  __set : (name,val)=>
    Main.messanger.query 'connectorVarSet',@__data.id,name,val
  __on    : (action,func)=>
    yield Main.messanger.receive "connectorEmit:#{@__data.id}:#{action}",func
    Main.messanger.query 'connectorOn',@__data.id,action
  __emit  : (action,data...)=>
    Main.messanger.query 'connectorEmit',@__data.id,action,data...


module.exports = SlaveProcessConnect


