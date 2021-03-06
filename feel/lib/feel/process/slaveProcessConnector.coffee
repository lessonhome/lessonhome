

blackList = require './blackList'
global.SLAVEPOCESSCONNECTORID = 0

###
# conf:
#   type: 'masterProcessManager'
#
###

class SlaveProcessConnector
  constructor : (@conf)->
    @id = global.SLAVEPOCESSCONNECTORID++
    @dataArray = {
      functions : []
      vars      : []
      id        : @id
    }
    @isOn = {}
    Wrap @
  init : =>
    switch @conf.type
      when 'slaveServiceManager'
        @target = Main.serviceManager
      when 'service'
        @target = yield Main.serviceManager.getById @conf.id
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
      Main.messanger.send "connectorEmit:#{@id}:#{action}",args...
  qEmit     : (action,data...)=>
    @target.emit action,data...
  connect : =>


module.exports = SlaveProcessConnector

