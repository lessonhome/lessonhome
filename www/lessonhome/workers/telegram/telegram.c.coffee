
telegram = require 'node-telegram-bot-api'

_logins =
  lessonhome : 'cheburashka'
os = require 'os'
hostname = os.hostname()

_rj_c = require('request-json').createClient('http://sheepridge.pandorabots.com/')

class Telegram
  init : =>
    @jobs = yield _Helper('jobs/main')
    @redis = yield _Helper('redis/main').get()
    yield @init_alice()

    keys =
      production  : '216886462:AAE2imVL1-m5IAkR1FrqzjXd_nfxaWp1PDE'
      develop     : '160978249:AAHPKc8R26yy-WKdnETf641bZo_6hVDO8Dc'
      local       : '205582731:AAEmqztEko77E0xjBMMoutTbQ24hHzr2p78'
    switch hostname
      when 'pi0h.org'       then  key = keys.production
      when 'lessonhome.org' then  key = keys.develop
      else                        return #key = keys.local
    @bot = new telegram key, polling : true
    @auth = {}
    @auth = yield _invoke @redis,'hgetall','telegramAuth'
    @auth ?= {}
    @auth[id] = JSON.parse(o || "{}") ? {} for id,o of @auth
    
    yield @bot.on 'message',@onmessage
    @unsecure =
      start : true
      auth  : true
    yield @jobs.listen 'telegramSendAll',@jobTelegramSendAll
  onmessage : (msg)=>
    m = msg.text.match(/^\/(\w+) ?(.*)?/)
    cmd_func = "cmd_#{m[1]}"
    if @[cmd_func]?
      return yield @status msg,'you have to "/auth login password" first' unless @unsecure[m[1]]
      yield @[cmd_func]? msg,(m[2] || "").split(/\s+/)...

  cmd_start : (msg)=>
    yield @bot.sendMessage msg.from.id,"Hello, "+msg.from.first_name+"!"

  cmd_auth : (msg,login,password)=>
    return yield @status msg unless (_logins[login]?) && (_logins[login]==password)
    @auth[msg.from.id] ?= {}
    @auth[msg.from.id].login = login
    yield _invoke @redis, 'hset','telegramAuth',msg.from.id, JSON.stringify @auth[msg.from.id]
    return yield @status msg,'thanks'
    
  status : (msg,text='failed :(')=>
    return yield @bot.sendMessage msg.from.id,text
   
  jobTelegramSendAll : (text)=>
    qs = for id of @auth then @bot.sendMessage id,text
    yield Q.all qs
  
  init_alice : =>
    return unless hostname == 'lessonhome.org'
    @alice_bot = new telegram '197380826:AAE2UoiB4mCuN6aTaZgYub_dKCKGYn7LfEw',polling:true
    yield @alice_bot.on 'message',@alice
  alice : (msg)=> Q.spawn =>
    return unless hostname == 'lessonhome.org'
    return if msg.text.match /[а-яё]/gmi
    data =
      botcust2:'8ae333b16e7d433c'
      input : msg.text
    ret = yield _requestPost
      url :'http://sheepridge.pandorabots.com/pandora/talk?botid=b69b8d517e345aba&skin=custom_input'
      form : data
    if ret[1]? then body = ret[1]
    else body = ret.body
    return unless body
    body = body.replace /\r|\n/gmi,' '
    m = body.match /\<b\>A\.L\.I\.C\.E\.\:\<\/b\>([^\<]+)\<br\/\>/
    text = m[1]?.replace(/^\s+/,'').replace(/\s+$/,'')
    return unless text

    yield @alice_bot.sendMessage msg.chat.id,text
    

module.exports = Telegram
