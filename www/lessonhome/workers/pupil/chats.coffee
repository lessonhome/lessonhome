
Chat = require './chat'


class Chats
  constructor : (@main)->
    $W @
    @chats = hash:{}
  init : =>
    yield @reloadDb()

  reloadDb : =>
    db = yield _invoke @main.dbChat.find({}),'toArray'
    db ?= []
    chats = {hash:{}}
    for chatdb in db
      chat = new Chat @main
      try
        yield chat.init chatdb
      catch e
        continue if e == 'delete'
        throw e
      chats.hash[chat.data.hash] = chat
    @chats = chats
  get : (hash)=>
    return @chats.hash[hash] if @chats?.hash?[hash]?
    return yield @create hash
  create : (hash)=>
    chat = new Chat @main
    yield chat.init {hash}
    chats.hash[chat.data.hash] = chat
    return chat
  msgPush : (auth,hash,msg)=>
    return console.error('io auth error') unless hash.split(':')?[0] == auth.id
    # @main.io => my class for work with socketio
    # @main.io.io variable with socket.io object in my class
    # @main.io.io.io object in socket.io for work with socketio rooms
    @main.io.io.io.to("uid:#{auth.id}").emit('chatPush:'+hash,msg)
    chat = yield @get hash
    yield chat.push msg
  getAdminChatForUserBid : (userId,bidIndex)=> @get "#{userId}:#{bidIndex}:admin"


module.exports = Chats
