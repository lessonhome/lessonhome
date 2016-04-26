


class Io
  constructor : (@main)->
    $W @
    @locker = $Locker()

  ########################################
  init : => @locker.$lock =>
    @io = _Helper 'socket.io/main'
    @io.on 'connection',@ioconnection

  run : => @locker.$lock =>

  ########################################
  ioconnection : (socket)=>
    socket.rname = "uid:#{socket.user.id}"
    socket.join socket.rname
    @emit 'connect',socket

module.exports = Io



