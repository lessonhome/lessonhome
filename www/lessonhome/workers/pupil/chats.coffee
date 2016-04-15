
Chat = require './chat'


class Chats
  constructor : (@main)->
    $W @
    @chats = hash:{}
    @locker = $Locker()

  ###################################
  init : => @locker.$lock =>
    yield @reloadDb()

  run : => @locker.$free =>

  get : (hash)=> @locker.$free =>
    return @chats.hash[hash] if @chats?.hash?[hash]?
    return yield @create hash
  
  msgPush : (auth,hash,msg)=> @locker.$free =>
    return console.error('io auth error') unless hash.split(':')?[0] == auth.id
    # @main.io => my class for work with socketio
    # @main.io.io variable with socket.io object in my class
    # @main.io.io.io object in socket.io for work with socketio rooms
    @main.io.io.io.to("uid:#{auth.id}").emit('chatPush:'+hash,msg)
    chat = yield @get hash
    yield chat.push msg
  
  create : (hash)=> @locker.$flock =>
    return @chats.hash[hash] if @chats?.hash?[hash]?
    chat = new Chat @main
    yield chat.init {hash}
    @chats.hash[chat.data.hash] = chat
    return chat
  
  getAdminChatForUserBid : (userId,bidIndex)=> @get "#{userId}:#{bidIndex}:admin"

  updatedPupil : (pupil)=> @locker.$async =>
    f = hash:$in:[]
    for acc in pupil.accounts
      f.hash.$in.push new RegExp "^#{acc}:.*"
    found = yield _invoke @main.dbChat.find(f,{hash:1}),'toArray'
    found ?= []
    qs = []
    for chat in found
      continue unless found.hash
      newhash = found.hash.split ':'
      newhash[0] = pupil.account
      newhash = newhash.join ':'
      qs.push _invoke @main.dbChat,'update',{hash:found.hash},{$set:hash:newhash}
    yield Q.all qs
    yield @reloadDb()
  
  ###################################
  reloadDb : =>
    db = yield _invoke @main.dbChat.find({}),'toArray'
    db ?= []
    for hash,chat of (@chats?.hash ? {})
      yield chat.destruct()
    @chats = {hash:{}}
    for chatdb in db
      chat = new Chat @main
      try
        yield chat.init chatdb
      catch e
        continue if e == 'delete'
        throw e
      @chats.hash[chat.data.hash] = chat

  


module.exports = Chats
