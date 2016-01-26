

ServiceWrapper = require './serviceWrapper'

global.SLAVESERVICEID = 0

class Service
  constructor : (@conf)->
    Wrap @
    @name = @conf.name
    @id = SLAVESERVICEID++
    @path = process.cwd()+"/feel/lib/feel/"+@conf.bin
    @ee = new EE
    #@log @name
    Class   = require @path
    @service  = new Class()
    Wrap @service
    @wrapper = new ServiceWrapper @service
    @wrapper.__serviceName  = @name
    @wrapper.__serviceId    = @id
  init : (args...)=>
    args ?= @conf.args if @conf?.args?
    yield @service.init args...
    return @wrapper
  run : (args...)=>
    yield @service.run? args...
    return
  get  : => @wrapper

module.exports = Service


