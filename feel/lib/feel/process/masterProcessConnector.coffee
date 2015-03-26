


global.MASTERPROCESSCONNECTORID = 0
blackList = require './blackList'

###
# conf:
#   type: 'masterProcessManager'
#
###

class MasterProcessConnector
  constructor : (@conf,@process)->
    @id = global.MASTERPROCESSCONNECTORID++
    @dataArray = {
      functions : []
      vars      : []
      id        : @id
    }
    @isOn = {}
    Wrap @
  init : =>
    switch @conf.type
      when 'masterProcessManager'
        @target = Main.processManager
      when 'masterServiceManager'
        @target = Main.serviceManager
      when 'serviceNearest'
        @target = yield Main.serviceManager.get @conf.name
      else
        throw new Error 'bad description of processConnector'
    for key,val of @target
      continue if blackList key
      if typeof val == 'function'
        @dataArray.functions.push key
      else
        @dataArray.vars.push key
  data      : => @dataArray
  qFunction : (name,args...)=>  @target[name] args...
  qVarGet   : (name)=>          @target[name]
  qVarSet   : (name,val)=>      @target[name] = val
  qOn       : (action)=>
    return if @isOn[action]
    @isOn[action] = true
    @target.on action, (args...)=>
      @process.send "connectorEmit:#{@id}:#{action}",args...
  qEmit     : (action,data...)=>
    @target.emit action,data...
  connect : =>


module.exports = MasterProcessConnector

