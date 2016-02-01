
_rj_c = require('request-json').createClient('http://json.gate.iqsms.ru/')


class Sms
  constructor : ->
    $W @
    @cid = 0
  init : =>
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'sendSms',@send
  send : (messages,sender='lessonhome')=>
    for m in messages
      m.phone = m.phone.replace /\D/gmi,''
      m.phone = '8'+m.phone if m.phone.length == 10
      m.clientId = @cid++
      m.sender = sender
    #message = encodeURIComponent message
    #phone = phone.replace(/\D/gmi).substr -10
    #phone = phone.substr -10
    data =
      login     : 'z1444311727400'
      password  : '279215'
      messages  : messages
    
    ret = yield Q.ninvoke _rj_c,'post', 'send/',data
    t = new Date().getTime()
    throw new Error "Failed sms" unless ret.body?
    throw ret.body unless ret.body.status == 'ok'
    console.log ret.body
    first = ret.body
    check =
      login   : 'z1444311727400'
      password: '279215'
      messages: []
    for m in ret.body.messages
      check.messages.push
        clientId:m.clientId
        smscId : m.smscId
    yield Q.delay 100
    que = true
    while que
      que = false
      ret = yield Q.ninvoke _rj_c,'post','status/',check
      throw new Error 'Failed sms' unless ret.body?
      throw ret.body unless ret.body.status == 'ok'
      console.log ret.body, (new Date().getTime())-t
      for m in ret.body.messages
        if m.status == 'queued'
          que = true
          yield Q.delay 500
          break
      if (new Date().getTime()-t)>(1000*30)
        break
    return [first,ret?.body] ? {}



module.exports = Sms


