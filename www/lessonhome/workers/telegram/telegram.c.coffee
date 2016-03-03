
telegram = require 'node-telegram-bot-api'

_logins =
  lessonhome : 'cheburashka'
os = require 'os'
hostname = os.hostname()

_rj_c = require('request-json').createClient('http://sheepridge.pandorabots.com/')

_num = (n)=>
  return ""+n if n > 9
  return '0'+n

class Telegram
  init : =>
    @jobs = yield _Helper('jobs/main')
    @redis = yield _Helper('redis/main').get()
    yield @init_alice false

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
    yield @bot.sendMessage msg.chat.id,"Hello, "+msg.from.first_name+"!"

  cmd_auth : (msg,login,password)=>
    return yield @status msg unless (_logins[login]?) && (_logins[login]==password)
    @auth[msg.chat.id] ?= {}
    @auth[msg.chat.id].login = login
    yield _invoke @redis, 'hset','telegramAuth',msg.chat.id, JSON.stringify @auth[msg.chat.id]
    return yield @status msg,'thanks'
    
  status : (msg,text='failed :(')=>
    return yield @bot.sendMessage msg.chat.id,text
   
  jobTelegramSendAll : (text)=>
    qs = for id of @auth then @bot.sendMessage id,text
    yield Q.all qs
  
  init_alice : (force=false)=>
    @audio_cache = yield _invoke @redis,'hgetall','audio_cache'
    @audio_cache ?= {}
    for key,val of @audio_cache
      @audio_cache[key] = JSON.parse val
    if force
      key = '130213602:AAHekroPCeAMo2f5P6BSYRhSi4FlrLlNMYM'
    else if hostname == 'lessonhome.org'
      key = '197380826:AAE2UoiB4mCuN6aTaZgYub_dKCKGYn7LfEw'
    else return
    @alice_bot = new telegram key,polling:true
    yield @alice_bot.on 'message',@alice
  alice : (msg)=> Q.spawn =>
    return unless msg?.text
    mtr = msg.text.replace(/\@\w+/,'')
    console.log @audio_cache[mtr],mtr
    if @audio_cache?[mtr]
      return yield @sendAudio msg, @audio_cache?[mtr]
      return
    cmd = msg.text.split(/\s+/)?[0] ? ""
    cmd = cmd.toLocaleLowerCase()
    switch cmd
      when 'find','afind','аштв','фаштв','get','aget','фпуе','пуе','photo','фото'
        return @alice_audio msg
    return if msg.text.match /[а-яё]/gmi
    return unless msg.text.match /\w/gmi
    yield @alice_bot.sendChatAction msg.chat.id,'typing'
    data =
      botcust2:'8ae333b16e7d433c'
      input : msg.text
    ret = yield _requestPost
      url :'http://sheepridge.pandorabots.com/pandora/talk?botid=b69b8d517e345aba&skin=custom_input'
      form : data
    if ret[1]? then body = ret[1]
    else body = ret.body
    return unless body
    body = body.replace /\r|\n/gmi,'`'
    m = body.match /\<b\>A\.L\.I\.C\.E\.\:\<\/b\>([^\`]+)/
    text = m[1]?.replace(/^\s+/,'').replace(/\s+$/,'')
    text = text.replace(/\<br\/\>/gmi,'')
    str = text
    str=str.replace(/<br>/gi, "\n")
    str=str.replace(/<p.*>/gi, "\n")
    str=str.replace(/<a.*href="(.*?)".*>(.*?)<\/a>/gi, " $2 (Link->$1) ")
    str=str.replace(/<img.*src="(.*?)".*>(.*?)<\/img>/gi, " $2 (Link->$1) ")
    str=str.replace(/<(?:.|\s)*?>/g, "")
    return unless str

    yield @alice_bot.sendMessage msg.chat.id,str
  alice_audio : (msg)=>
    arg = msg.text.split /\s+/
    str = ""
    cmd = arg.shift()
    cmd2 = null
    cmd2 = +arg.shift() if arg[0].match /^\d+$/
    cmd3 = +arg.shift() if arg[0].match /^\d+$/
    cmd3 ?= 0
    cmd = cmd.replace /\@\w+/,''
    cmd = cmd.toLocaleLowerCase()
    switch cmd
      when 'find','afind','аштв','фаштв'
        yield @alice_bot.sendChatAction msg.chat.id,'typing'
        items = yield @audioFind arg.join(' '),cmd2,cmd3
        str = ""
        @audio_cache ?= {}
        for it,i in items
          key_ = "/a#{_num(i+1)}"
          @audio_cache[key_] = it
          _invoke(@redis,'hset','audio_cache',key_,JSON.stringify it).done()
          str += "#{key_}\t #{it.artist.substr(0,30)}\t- #{it.title.substr(0,40)} #{_num it.duration//60}:#{_num it.duration%60}\n"
      when 'get','aget','фпуе','пуе'
        items = yield @audioFind arg.join(' '),(cmd2 ? 1),cmd3
        for item in items
          yield @sendAudio msg,item
        return
      when 'photo','фото'
        ret = yield _wget 'https','www.google.ru','/search?newwindow=1&source=lnms&tbm=isch&sa=X&q='+encodeURIComponent(arg.join(' '))
        #ret = yield _wget 'https','www.google.ru','/search?newwindow=1&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiNqb6syqTLAhXpHJoKHeAdAf4Q_AUICCgC&biw=1463&bih=950&q='+encodeURIComponent(arg.join(' '))
        imgs = ret?.data?.match?(/\<img[^\<]+src\=\"([^\"]+static[^\"]+)\"/gmi) ? []
        boo = false
        srcs = []
        for img in imgs
          src = img?.match?(/src\=\"(.*)\"/)?[1]
          if src
            srcs.push src
            boo = true
        cmd2 ?= 5
        if cmd2
          srcs = srcs.splice cmd3,cmd2
        yield @sendPhotos msg,srcs if boo
        return if boo
    str = str || 'не найдено'
    yield @alice_bot.sendMessage msg.chat.id,str
  audioFind : (name,num=10,cmd3)=> yield @jobs.solve 'findAudio',name,num,cmd3
  sendAudio : (msg,audio)=>
    Q.spawn => yield @alice_bot.sendChatAction msg.chat.id,'upload_audio'
    num = 60/5
    int = setInterval =>
      num--
      if num < 0
        clearInterval int
      Q.spawn => yield @alice_bot.sendChatAction msg.chat.id,'upload_audio'
    , 5000
    yield @loadAudioFile msg,audio
    yield @sendAudioFile msg,audio
    clearInterval int
  sendPhotos : (msg,photos=[])=>
    Q.spawn => yield @alice_bot.sendChatAction msg.chat.id,'upload_photo'
    num = 60/5
    int = setInterval =>
      num--
      if num < 0
        clearInterval int
      Q.spawn => yield @alice_bot.sendChatAction msg.chat.id,'upload_photo'
    , 5000
    for src in photos then do (src)=> Q.spawn =>
      path = "#{process.cwd()}/.cache/#{_randomHash()}.jpg"
      yield _exec 'wget','-q','-O',path,src
      yield @alice_bot.sendPhoto msg.chat.id,path
      yield _rmrf path
    clearInterval int

  loadAudioFile : (msg,audio)=>
    return unless audio
    audio.path = "#{process.cwd()}/.cache/#{_randomHash()}.mp3"
    console.log 'load',audio.path
    yield _exec 'wget','-q','-O',audio.path,audio.url
  sendAudioFile : (msg,audio)=>
    return unless audio?.path
    console.log 'send', audio.path
    yield @alice_bot.sendAudio msg.chat.id,audio.path,
      duration : audio.duration
      performer : audio.artist
      title : audio.title
    yield _rmrf audio.path



module.exports = Telegram
