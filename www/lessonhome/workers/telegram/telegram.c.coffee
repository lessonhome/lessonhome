
telegram = require 'node-telegram-bot-api'

_logins =
  lessonhome : 'cheburashka'
os = require 'os'
hostname = os.hostname()
class Telegram
  init : =>
    @jobs = yield _Helper('jobs/main')
    @redis = yield _Helper('redis/main').get()

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


module.exports = Telegram
