

class ServiceWrapper
  constructor : (@__service)->
    Wrap @
    @__ee = new EE
  __init : =>
    _emit = @__service.emit
    @__service.emit = (args...)=>
      @__ee.emit args...
      _emit.apply @__service,args...
    for key,val of @__service
      if typeof val == 'function'
        do (key)=> @[key] = => @__service[key] arguments...
      else
        do (key)=>
          Object.defineProperty @,key,
            get :      => @__service[key]
            set : (val)=> @__service[key] = val


module.exports = ServiceWrapper
