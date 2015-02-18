

ServiceWrapper = require './serviceWrapper'


class Service
  constructor : (@conf)->
    Wrap @
    @path = process.cwd()+"/feel/lib/feel/"+@conf.bin
    @ee = new EE
  init : (args...)=>
    console.log 'init'
    args ?= @conf.args if @conf?.args?
    console.log 'init'
    Class   = require @path
    console.log 'init'
    console.log Class
    @service  = new Class()
    Wrap @service
    @wrapper = new ServiceWrapper @service
    yield @wrapper.__init()
    yield @service.init args...
    return @wrapper
  get  : => @wrapper

module.exports = Service


