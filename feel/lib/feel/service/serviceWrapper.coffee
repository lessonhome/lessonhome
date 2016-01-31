

blackList = require '../process/blackList'

class ServiceWrapper
  constructor : (@__service)->
    Wrap @
    ee = new EE
    _emit = @__service.emit
    @__service.emit = (args...)=>
      ee.emit args...
      _emit.apply @__service,args
    for key,val of @__service
      continue if blackList key
      if typeof val == 'function'
        do (key)=> @[key] = => @__service[key] arguments...
      else
        do (key)=>
          @[key] = val
          Object.defineProperty @,key,
            get :      => @__service[key]
            set : (val)=> @__service[key] = val
    @on   = (args...)=> ee.on   args...
    @once = (args...)=> ee.once args...
    @emit = (args...)=> @__service.emit args...


module.exports = ServiceWrapper
