



class Pupil
  init : =>
    @jobs   = yield _Helper 'jobs/main'
    @redis  = yield _Helper('redis/main').get()
    @db     = yield Main.service 'db'

    @dbBids = yield @db.get 'bids'
    @dbChat = yield @db.get 'chat'
    @dbPupil = yield @db.get 'pupil'

    @chats = {}
    @pupil = {}

    yield @jobs.listen 'pupilGetPupil',@jobPupilGetPupil
    yield @jobs.listen 'pupilGetBids',@jobPupilGetBids

    yield @jobs.client 'pupilChatPush',@jobPupilChatPush
    yield @jobs.client 'pupilUpdateBid',@jobPupilUpdateBid
    yield @jobs.client 'pupilUpdatePupil',@jobPupilUpdatePupil
  
  _getID : (_id)=> new (require('mongodb').ObjectID)(_id)
  checkBidIndex :  (bid)=>
    return if bid.index
    id = @_getID bid._id
    
    bid.index = _randomHash(8)
    console.log bid.index
    yield _invoke @dbBids,'update',{_id:id},{$set:{index:bid.index}},{upsert:false}
 
  jobPupilGetPupil : (id)=>
    return @pupil[id] if @pupil[id]
    pupil = yield _invoke @dbPupil.find({account:id}).limit(1),'toArray'
    pupil = pupil?[0]
    unless pupil
      pupil = {account:id}
      bids = yield _invoke @dbBids.find({account:id}).sort({time:-1}),'toArray'
      for bid in bids ? []
        pupil.name = pupil.name || bid.name
        pupil.phone = pupil.phone || bid.phone
        pupil.registerTime = bid.time if bid.time
      yield _invoke @dbPupil,'update',{account:id},{$set:pupil},{upsert:true}
    @pupil[id] = pupil
    return pupil

  jobPupilGetBids : (id)=>
    bids = yield _invoke @dbBids.find({account:id}).sort({time:-1}),'toArray'
    bids ?= []
    for bid,i in bids
      yield @checkBidIndex bid
      chatAdmin = yield @chatGet "#{id}:#{bid.index}:admin"
      tutors  = {}
      if bid.id
        tutors[bid.id] ?= {}
        tutors[bid.id].chat ?= yield @chatGet "#{id}:#{bid.index}:#{bid.id}"
        unless tutors[bid.id].chat.messages.length
          yield @chatPush tutors[bid.id].chat.hash,{
            text : bid.comments
            time : bid.time
          }
        tutors[bid.id].type ?= "message"
      for key,val of bid.linked ? {}
        tutors[key] ?= {}
        tutors[key].chat ?= yield @chatGet "#{id}:#{bid.index}:#{key}"
        tutors[key].type ?= "linked"
      keys = Object.keys tutors
      data = yield @jobs.solve 'getTutors',keys if keys.length
      for key,val of tutors
        tutors[key].data = data[key] if data[key]
      bids[i] =
        bid : bid
        tutors : tutors
        chat : chatAdmin
    return bids
  jobPupilUpdateBid : (auth,index,data)=>
    yield _invoke @dbBids,'update',{account:auth.id,index:index},{$set:data}
  jobPupilUpdatePupil : (auth,data={})=>
    if @pupil[auth.id]
      for key,val of data
        @pupil[auth.id][key] = val
    yield _invoke @dbPupil,'update',{account:auth.id},{$set:data},{upsert:true}

  jobPupilChatPush : (auth,hash,msg)=>
    if hash.split(':')?[0] == auth.id
      yield @chatPush hash,msg
  chatGet : (hash)=>
    return @chats[hash] if @chats[hash]?
    chat = yield _invoke @dbChat.find({hash:hash}).limit(1),'toArray'
    chat = chat?[0] ? {hash}
    chat.messages ?= []
    @chats[hash] = chat
    return chat
  chatPush : (hash,msg)=>
    @chats[hash].messages?.push msg if @chats[hash]?
    yield _invoke @dbChat,'update',{hash:hash},{$push:{messages:msg}},{upsert:true}


module.exports = Pupil


