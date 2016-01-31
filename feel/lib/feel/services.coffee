
Service = require './service'

class Services extends EE
  constructor : ->
    @counter = 0
    @services ?= []
  start : (name,args={})=>
    args.name = name
    service = new Service name,@counter++
    return Q()
    .then =>
      service.init args
    .then =>
      @services[name] = service
      @services.push    service
      service.on 'destruct', =>
        for s,i in @services
          if s.index = service.index
            @services.splice i,1
            break
        if @services?[name]?.index == service?.index
          delete @services[name]
    .then =>
      service.messenger.on "fork", => @fork service.messenger,arguments...
      return service.messenger
  fork : (listener,name,id,args)=>
    @start(name,args)
    .then (messenger)=>
      service = messenger.service
      service.on 'disconnect',  =>
        listener.emit "#{id}:disconnect",arguments...
      service.on 'exit',        =>
        listener.emit "#{id}:exit",      arguments...
      service.on 'message',     =>
        listener.emit "#{id}:message",   arguments...
      service.on 'online',      =>
        listener.emit "#{id}:online",    arguments...
      listener.on "#{id}:send", (o)=>
        messenger.emit o.msg, o.args...


module.exports = Services



