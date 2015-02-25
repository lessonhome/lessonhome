

MasterProcessConnect = require '../process/masterProcessConnect'

global.MASTERSERVICEMANAGERSERVICEID = 0

class MasterServiceManager
  constructor : ->
    Wrap @
    @config = {}
    @services =
      byProcess : {}
      byId      : {}
      byName    : {}

  init : =>
    @log()
    configs = yield _readdir 'feel/lib/feel/service/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require "./config/#{name}"
      @config[m[1]].name = m[1]
  run  : =>
  getConfig : (name)=> @config[name]
  connectService : (processId,serviceId)=>
    process = yield Main.processManager.getProcess processId
    service = new MasterProcessConnect {
      type  : 'service'
      id    : serviceId
    }, process
    yield service.init()
    wrapper = service
    masterId  = MASTERSERVICEMANAGERSERVICEID++
    name      = yield service.__serviceName
    @log "#{process.name}:#{processId}:#{name}"
    @services.byProcess[processId] ?= {}
    @services.byProcess[processId][serviceId] = wrapper
    @services.byId[masterId] = wrapper
    @services.byName[name] ?= []
    @services.byName[name].push wrapper
module.exports = MasterServiceManager



