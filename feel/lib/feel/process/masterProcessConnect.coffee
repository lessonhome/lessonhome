
blackList = require './blackList'


class MasterProcessConnect
  constructor : (@__conf,@__process)->
    @__conf = type:@__conf if typeof @__conf == 'string'
    @__conf.processId = 'master'
    Wrap @
  __init : =>
    @__data = yield @__process.query 'connect',@__conf
    for func in @__data.functions
      continue if blackList func
      do (func)=>
        @[func] = (args...)=> @__function func,args...
    for name in @__data.vars
      continue if blackList name
      do (name)=>
        @[name] = 'UNDEFINED'
        Object.defineProperty @,name,
          get :     =>  @__get name
          set :(val)=>  @__set name,val
    @on   = @__on
    @emit = @__emit
  __function : (name,args...)=>
    @__process.query 'connectorFunction',@__data.id,name,args...
  __get : (name)=>
    @__process.query 'connectorVarGet',@__data.id,name
  __set : (name,val)=>
    @__process.query 'connectorVarSet',@__data.id,name,val
  __on    : (action,func)=>
    yield @__process.receive "connectorEmit:#{@__data.id}:#{action}",func
    @__process.query 'connectorOn',@__data.id,action
  __emit  : (action,data...)=>
    @__process.query 'connectorEmit',@__data.id,action,data...


module.exports = MasterProcessConnect


