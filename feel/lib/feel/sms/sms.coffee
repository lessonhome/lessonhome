
_rj_c = require('request-json').createClient('http://json.gate.iqsms.ru/')

os = require 'os'
hostname = os.hostname()

class Sms
  constructor : ->
    $W @
    @cid = 0
  init : =>
    @redis = yield _Helper('redis/main').get()
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'sendSms',@send
    yield @genUrls()
    if _production
      @prot = 'https'
      switch hostname
        when 'lessonhome.org'
          @host = 'lessonhome.ru'
        when 'lessonhome.ru'
          @host = 'lessonhome.org'
      @recacheFriend 60*1000 if @host
    else
      @prot = 'http'
      @host = '127.0.0.1'
      #@recacheFriend 30*1000 if @host
    
  genUrls : =>
    @consts = yield @jobs.solve 'getConsts'
    @pages =  @consts['pages'].main
    states = yield @jobs.solve 'getAllStates'
    for key,val of states
      @pages.push key if val.match /reclame_jump_page_templates/
  recacheFriend : (timed)=> Q.spawn =>
    yield Q.delay 5000
    while true
      t = new Date().getTime()
      for url in @pages
        for i in [1..1]
          nt = new Date().getTime()
          ret = yield _wget @prot,@host,url
          size = Math.ceil ret.data.length/1024
          nt = (new Date().getTime()-nt)
          console.log url.red,"#{ret.statusCode} #{size}Kb #{nt}ms".yellow
      console.log "finish recache",new Date().getTime()-t
      yield Q.delay timed


    
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


