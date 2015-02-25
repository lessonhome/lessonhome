

ServiceWrapper = require './serviceWrapper'

global.SLAVESERVICEID = 0

class Service
  constructor : (@conf)->
    @name = @conf.name
    @id = SLAVESERVICEID++
    Wrap @
    @path = process.cwd()+"/feel/lib/feel/"+@conf.bin
    @ee = new EE
  init : (args...)=>
    @log @name
    args ?= @conf.args if @conf?.args?
    Class   = require @path
    @service  = new Class()
    Wrap @service
    @wrapper = new ServiceWrapper @service
    @wrapper.__serviceName  = @name
    @wrapper.__serviceId    = @id
    yield @wrapper.__init()
    yield @service.init args...
    return @wrapper
  get  : => @wrapper

module.exports = Service


