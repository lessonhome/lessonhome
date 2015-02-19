

ServiceWrapper = require './serviceWrapper'


class Service
  constructor : (@conf)->
    Wrap @
    @path = process.cwd()+"/feel/lib/feel/"+@conf.bin
    @ee = new EE
  init : (args...)=>
    args ?= @conf.args if @conf?.args?
    Class   = require @path
    @service  = new Class()
    Wrap @service
    @wrapper = new ServiceWrapper @service
    yield @wrapper.__init()
    yield @service.init args...
    return @wrapper
  get  : => @wrapper

module.exports = Service


