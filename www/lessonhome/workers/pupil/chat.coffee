

class Chat
  constructor : (@main)->
    $W @

  init : (data)=>
    try
      @data = yield @checkData data
    catch e
      yield @deleteChat data if e == 'delete'
      throw e
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

  push : (msg)=>
    @data.messages.push msg
    Q.spawn =>
      yield _invoke @main.dbChat,'update',{hash:data.hash},{$push:{messages:msg}}
  deleteChat : (data=@data)=>
    return unless data._id
    yield _invoke @main.dbChat,'remove',{_id:@main._getID(data._id)}
  getData : =>
    return @data
    

module.exports = Chat


