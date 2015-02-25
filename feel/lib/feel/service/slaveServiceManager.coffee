
util = require 'util'

SlaveProcessConnect = require '../process/slaveProcessConnect'
Service               = require './service'

class SlaveServiceManager
  constructor : ->
    Wrap @
    @services =
      self    : {}
      master  : {}
      others  : {}
    @servicesById = {}
  init : =>
    @log()
    @master = new SlaveProcessConnect 'masterServiceManager'
    yield @master.init()
  nearest : (name)=>
    return @choose(@services.self[name]).wrap if @services.self[name]?[0]?
    return @choose(@services.master[name]).wrap if @services.master[name]?[0]?
    return @choose(@services.others[name]).wrap if @services.others[name]?[0]?
    @masterNearest(name)
  choose : (array)=>
    throw new Error 'cant choose service bad array' unless util.isArray(array) && array.length
    return array[Math.floor(Math.random()*array.length)].wrap

  masterNearest : (name)=>
  
  start   : (name)=>
    @log name
    conf    = yield @master.getConfig name
    #try return @nearest name if conf.single
    service = new Service conf
    @servicesById[service.id] = service
    @services.self[name] ?= []
    @services.self[name].push service
    wrapper = yield service.init()
    yield @connectServiceToMaster service
    return wrapper
  connectServiceToMaster : (service)=>
    @master.connectService Main.processId,service.id

    

module.exports = SlaveServiceManager

