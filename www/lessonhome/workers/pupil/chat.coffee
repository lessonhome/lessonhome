

class Chat
  constructor : (@main)->
    $W @
    @locker = $Locker()

  ####################################################
  init : (data)=> @locker.$lock =>
    try
      @data = yield @checkData data
    catch e
      yield @deleteChat data if e == 'delete'
      throw e
  
  destruct : => @locker.$lock =>
  
  push : (msg)=> @locker.$lock =>
    @data.messages.push msg
    yield _invoke @main.dbChat,'update',{hash:data.hash},{$push:{messages:msg}}
  
  getData : => @locker.$free =>
    return @data
  
  ####################################################
  checkData : (data=@data)=>
    try
      [@from_id,@bid_id,@to_id] = data.hash.split ':'
    catch e
      console.error Exception e
      console.error data
      throw 'delete'

    data.messages ?= []

    yield @_write data
    return data
  _write : (data=@data)=>
    __hash = @main.hash data
    return if __hash == data.__hash
    data.__hash = __hash
    yield _invoke @main.dbChat,'update',{hash:data.hash},{$set:data}
    unless data._id
      ret = yield _invoke @main.dbChat.find({hash:data.hash},{_id:1}),'toArray'
      data._id = ret?[0]?._id
  deleteChat : (data=@data)=>
    return unless data._id
    yield _invoke @main.dbChat,'remove',{_id:@main._getID(data._id)}
    

module.exports = Chat


