

class TelegramApi
  constructor : ->
    $W @

  init : =>

  msg : (phone,message)=>
    console.log 'msg',phone,message
    user = yield @getUser phone
    return unless user?.id
    return yield @exec "msg #{user.id} '#{message}'"

  getUser : (phone)=>
    user = yield @exec "add_contact '#{phone}' '#{phone}' '#{phone}'"
    user = user?[0]
    return {} unless user?.id
    return user

  exec : (cmd)=>
    ret = yield _exec "#{process.cwd()}/tg/run.sh",cmd
    ret = ret.split(/\n/)
    arr = []
    for a in ret
      a = a.replace(/\[K/gmi,'')
      a = a.replace(/^[^\{|\[]*/gmi,'')
      a = a.replace(/[^\}|\]]*$/gmi,'')
      continue unless a
      a = JSON.parse a
      arr.push a
    if arr.length == 1
      arr= arr[0]
    return arr

module.exports = TelegramApi

###
TelegramLink = require('telegram.link')()

conf =
  id : 25282
  hash : 'b334f72ad1a3d4e3324894ccde2d2dab'
  dc  :
    host : '149.154.167.50'
    port : '443'
  key : '-----BEGIN RSA PUBLIC KEY-----
  MIIBCgKCAQEAwVACPi9w23mF3tBkdZz+zwrzKOaaQdr01vAbU4E1pvkfj4sqDsm6
  lyDONS789sVoD/xCS9Y0hkkC3gtL1tSfTlgCMOOul9lcixlEKzwKENj1Yz/s7daS
  an9tqw3bfUV/nqgbhGX81v/+7RFAEd+RwFnK7a+XYl9sluzHRyVVaTTveB2GazTw
  Efzk2DWgkBluml8OREmvfraX3bkHZJTKX4EQSjBbbdJ2ZXIsRrYOXfaA+xayEGB+
    8hdlLmAjbCVfaigxX0CDqWeR1yFL9kwd9P0NsZRPsmoqVwMbMu7mStFai6aIhc3n
    Slv8kg9qv1m6XHVQY3PnEw+QQtqSIXklHwIDAQAB
    -----END RSA PUBLIC KEY-----'

class TelegramApi
  constructor : ->
    $W @
    @ee = new EE
  waitFor : (action)=>
    d = Q.defer()
    done = false
    @client.once 'error',(e)->
      return if done
      console.log "#{action}::err".red
      done = true
      d.reject e
    @client.once action,(args...)->
      return if done
      console.log "#{action}::ok".yellow
      done = true
      d.resolve args...
    @ee.once action,(args...)->
      return if done
      console.log "#{action}::ee::ok".yellow
      done = true
      d.resolve args...
    return d.promise

  init : =>
    @client = TelegramLink.createClient {
      id    : conf.id
      hash  : conf.hash
      version : "0.0.0"
      land : "ru"
      authKey : conf.key
      connectionType: 'TCP'
    }, conf.dc
    @client.on 'error',(err)=> console.error err
    yield @waitFor 'connect'
    @client.createAuthKey => @ee.emit 'authKeyCreate'
    yield @waitFor 'authKeyCreate'
    #yield @proxy()
    #console.log @client.auth.checkPhone
    #@client.auth.checkPhone '79267952303',=> console.log 'checkPhone',arguments...
    q = @waitFor 'sendCode'
    @client.auth.sendCode '79267952303',5,'en'
    ret = yield q
    console.log {ret}

    
  handler : =>
    get : (target,key)=>
      if typeof target[key] == 'function'
        (args...)=> _invoke target,'key',args...
      else
        return target[key]
  toHandle : ['auth']
  proxy : =>
    for key in @toHandle
      @[key] = {}
      for fname,foo of @client[key]
        continue unless typeof foo == 'function'
        do (key,fname)=>
          @[key][fname] = (args...)=> _invoke @client[key],'fname',args...
    #@[key] = new Proxy @client[key],@handler()
module.exports = TelegramApi

###


