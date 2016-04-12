



class Pupil
  constructor : (@main)->
    $W @
  init : (data)=>
    @data = yield @checkData data
  getData : => @data
 
  checkData : (data=@data,updateObj)=>
    startHash = _object_hash data
    #********************    
    if updateObj?
      for key,val of updateObj
        data[key] = val
        
    #********************
    endHash = _object_hash data
    unless startHash == endHash
      yield _invoke @main.dbPupil,'update',{account:data.account},{$set:data}
    return data
 
  update : (data)=>
    @data = yield @checkData @data,data


module.exports = Pupil


