

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

  push : (msg)=> @locker.$lock =>
    @data.messages.push msg
    yield _invoke @main.dbChat,'update',{hash:data.hash},{$push:{messages:msg}}
  
  getData : => @locker.$free =>
    return @data
  
  ####################################################
  checkData : (data=@data)=>
    startHash = _object_hash data
    #********************    
    
    try
      [@from_id,@bid_id,@to_id] = data.hash.split ':'
    catch e
      console.error Exception e
      console.error data
      throw 'delete'

    data.messages ?= []

    #********************
    endHash = _object_hash data
    unless startHash == endHash
      yield _invoke @main.dbChat,'update',{hash:data.hash},{$set:data}
    return data

  deleteChat : (data=@data)=>
    return unless data._id
    yield _invoke @main.dbChat,'remove',{_id:@main._getID(data._id)}
    

module.exports = Chat


