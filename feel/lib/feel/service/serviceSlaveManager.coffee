
util = require 'util'

SlaveProcessConnector = require '../process/slaveProcessConnector'

class ServiceSlaveManager
  constructor : ->
    Wrap @
    @services =
      self    : {}
      master  : {}
      others  : {}
    @master = new SlaveProcessConnector 'masterManager'
  init : =>
    yield @master.init()

  nearest : (name)=>
    return @choose(@services.self   [name]).wrap if @services.self  [name]?[0]?
    return @choose(@services.master [name]).wrap if @services.master[name]?[0]?
    return @choose(@services.others [name]).wrap if @services.others[name]?[0]?
    @masterNearest(name)
  choose : (array)=>
    throw new Error 'cant choose service bad array' unless util.isArray(array) && array.length
    return array[Math.floor(Math.random()*array.length)].wrap

  masterNearest : (name)=>

module.exports = ServiceSlaveManager

