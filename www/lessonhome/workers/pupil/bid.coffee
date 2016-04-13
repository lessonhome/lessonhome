

class Bid
  constructor : (@main)->
    $W @
    @locker = $Locker()

  ####################################################
  init : (data)=> @locker.$lock => # write to db depended
    @data = yield @checkData data
    
  getData : => @locker.$free =>
    adminChat =  yield @main.chats.getAdminChatForUserBid(@data.account,@data.index)
    return {
      bid     : @data
      chat    : yield adminChat.getData()
      tutors  : {}
    }

  update : (data)=> @locker.$lock => # write to db depended
    @data = yield @checkData @data,data
  
  linkTutorMessage : ({tutorIndex,message})=> @locker.$lock =>  # write to db
    tutor = yield @_linkTutor @data,tutorIndex,'message'
    if message
      chat = yield @main.chats.get "#{@data.account}:#{@data.index}:#{tutorIndex}"
      yield chat.push
        type : 'pupil'
        text : message
        time : @data.time
    yield @_write()

  #####################################################
  checkData : (data=@data,updateObj)=> # write to db
    startHash = _object_hash data
    #********************    
    if updateObj?
      for key,val of updateObj
        data[key] = val
    data.index = "#{data.index}"
    if data.index.match(/\D/) || (!data.index.match(/\d/))
      data.index = Math.floor(Math.random()*900000)+100000
    data.index = +data.index
    data.subjects ?= []

    unless data.subjects.length?
      data.subjects = Object.keys data.subjects
    if data.subject?
      data.subjects.push data.subject if data.subject
      delete data.subject
    
    if data.phone || data.name || data.email
      pupil = {}
      pupil.phone   = data.phone  if data.phone
      pupil.name    = data.name   if data.name
      pupil.email   = data.email  if data.email
      pupil.account = data.account
      yield @main.pupils.mergePupilInfo pupil
      delete data.phone
      delete data.name

    data.tutors ?= {}

    if data.linked?
      for tutorIndex of data.linked
        yield @_linkTutor data,tutorIndex,'linked'
      delete data.linked

    ss = {}
    for s in data.subjects
      ss[s] = true if s
    data.subjects = Object.keys(ss).sort()

    data.time ?= new Date()
    data.state ?= 'in_work'

    #********************
    endHash = _object_hash data
    if (!data._id) || (startHash != endHash)
      yield @_write data
    return data

  _write : (data=@data)=>
    yield _invoke @main.dbBids,'update',{_id:@main._getID(data._id)},{$set:data}

  _linkTutor : (data,tutorIndex,type)=>
    data.tutors[tutorIndex] ?= {}
    tutor = data.tutors[tutorIndex]
    tutor.data ?= {}
    tutor.type ?= type
    return tutor





module.exports = Bid
