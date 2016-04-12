


class Io
  constructor : (@main)->
    $W @

  init : =>
    @io = _Helper 'socket.io/main'
    @io.on 'connection',@ioconnection


  ioconnection : (socket)=>
    socket.rname = "uid:#{socket.user.id}"
    socket.join rname
    @emit 'connect',socket
    @main.pupils.ioConnect socket

module.exports = Io



