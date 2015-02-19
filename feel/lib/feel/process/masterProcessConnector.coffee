


global.MASTERPROCESSCONNECTORID = 0

###
# conf:
#   type: 'masterManager'
#
###

class MasterProcessConnector
  constructor : (@conf,@manager,@process)->
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
      when 'masterManager'
        @target = @manager
      else
        throw new Error 'bad description of processConnector'
    for key,val of @manager
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
    @target.on 'action', (args...)=>
      @process.send "connectorEmit:#{@id}:#{action}",args...
  qEmit     : (action,data...)=>
    @target.emit action,data...

module.exports = MasterProcessConnector


