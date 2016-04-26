

unset =
  subject : ""
  phone   : ""
  name    : ""
  email   : ""
  linked  : ""
  subject_comment : ""



class Bid
  constructor : (@main)->
    $W @
    @locker = $Locker()
  ####################################################
  init : (data)=> @locker.$lock => # write to db depended
    @data = yield @checkData data
   
  destruct : => @locker.$lock =>

  getData : => @locker.$free => @data
  getExtraData : => @locker.$free =>
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
      console.log {chat:chat.data.hash}
      yield chat.push
        type : 'pupil'
        text : message
        time : @data.time
    yield @_write()

  #####################################################
  checkData : (data=@data,updateObj)=> # write to db
    if updateObj?
      for key,val of updateObj
        data[key] = val
    
    data = @_prepareBid data

    yield @_write data

    @main.bids.bids.account[data.account] ?= {}
    @main.bids.bids.account[data.account][data.index] = @
    @main.bids.bids.index[data.index] = @

    return data

  _write : (data=@data)=>
    __hash = @main.hash data
    return if __hash == data.__hash
    data.__hash = __hash
    delete data._id
    yield _invoke @main.dbBids,'update',{index:data.index},{$set:data,$unset:unset},{upsert:true}
    unless data._id
      ret = yield _invoke @main.dbBids.find({index:data.index},{_id:1}),'toArray'
      data._id = ret?[0]?._id

  _linkTutor : (data,tutorIndex,type)-> # static
    data.tutors[tutorIndex] ?= {}
    tutor = data.tutors[tutorIndex]
    tutor.data ?= {}
    tutor.type ?= type
    return tutor

  _extractPupil : (bid)-> # static
    pupil =
      accounts : []
      phones : []
      emails : []
    
    if bid.account
      pupil.account = bid.account
      pupil.accounts.push bid.account
    pupil.phones.push bid.phone   if bid.phone
    pupil.emails.push bid.email   if bid.email
    pupil.registerTime = bid.time if bid.time
    pupil.name  = bid.name        if bid.name
    return pupil

  _prepareBid : (data)-> # static

    data.index = "#{data.index}"
    if data.index.match(/\D/) || (!data.index.match(/\d/))
      data.index = Math.floor(Math.random()*900000000)+100000000
    data.index = +data.index
    data.subjects ?= []

    unless data.subjects.length?
      data.subjects = Object.keys data.subjects
    if data.subject?
      data.subjects.push data.subject if data.subject
      delete data.subject
    
    data.comment ?= ''
    data.comment = data.subject_comment if data.subject_comment

    ###
    if data.phone || data.name || data.email
      pupil = {}
      pupil.phone   = data.phone  if data.phone
      pupil.name    = data.name   if data.name
      pupil.email   = data.email  if data.email
      pupil.account = data.account
      yield @main.pupils.mergePupilInfo pupil
      delete data.phone
      delete data.name
    ###
    
    data.tutors ?= {}
    if data.linked?
      for tutorIndex of data.linked
        Bid::_linkTutor data,tutorIndex,'linked'
      delete data.linked

    ss = {}
    for s in data.subjects
      ss[s] = true if s
    data.subjects = Object.keys(ss).sort()

    data.time ?= new Date()
    data.state ?= 'active'

    for del of unset
      delete data[del]

    return data
    
      





module.exports = Bid
