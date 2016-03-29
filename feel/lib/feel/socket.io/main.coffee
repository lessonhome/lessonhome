

_cookie   = require 'cookie'
_redis    = require('redis').createClient
_adapter  = require 'socket.io-redis'
_io       = require 'socket.io'


class SocketIO
  constructor : ->
    $W @
    
    @io = _io()
    @io.on 'connection', @connection
    
    if _production
      r =
        port : 36379
        pass : 'Savitri2734&'
      pub = _redis r.port,'127.0.0.1',{auth_pass:r.pass}
      sub = _redis r.port,'127.0.0.1',{auth_pass:r.pass,return_buffers:true}
      @io.adapter _adapter {pubClient:pub,subClient:sub}
    else
      @io.adapter _adapter {host:'127.0.0.1',port:6379}
    @io.listen 9050


  connection : (socket)=> Q.spawn =>
    cookies = (_cookie.parse socket?.handshake?.headers?.cookie ? "") ? {}
    @register ?= yield Main.service 'register'
    register = yield @register.register cookies.session,cookies.unknown,cookies.adminHash
    session = register.session
    user    = register.account
    socket.join "uid:#{user.id}"
    yield @emit 'connection',{socket,session,user}


module.exports = SocketIO



