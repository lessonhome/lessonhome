
###

На сервере доступны задачи:
  pupilGetPupil(id) : id - (from req.user.id)
    name          # параметры которые по умолчанию приходят с заявками
    registerTime
    phone
    ... плюс те которые ты передашь при обновлении профиля через функцию pupilUpdatePupil
  pupilGetBids(id) : # id - айдишник ученика (req.user.id)
    [
      {
        bid : {
          index:"adasdad"
          ... # данные заявки
        },
        chat : {
          hash : # уникальный хэш чата
          messages : [
            {text,time,...},{},{} # сообщения в том формате, в котором ты их будешь пушить
          ]
        },
        tutors : {      # массив с преподами
          #index1# : {  # индекс репетитора
            chat : {}      # аналогичный чат
            data : {}      # объект препода, такой же какой в карточки приходит
            type : 'linked' # тип связи с преподавателем
                            # linked - прикрепленный учеником
                            # message - сообщение преподу
                            # tutorback - препод сам захотел заявку
                            # moderator - модератор подобрал препода
          }
          #index2#... 
        }
        
      },
      ...
    ]

На клиенте:
  pupilUpdatePupil(data) # где data, данные, которые нужно обновить в общей инфе об ученике
  pupilUpdateBid(index,data) # где index - индекс заявки (bid.index), data - -||-
  pupilChatPush(hash,msg) # где hash- хэш чата, msg- объект сообщения чата которое надо запушить


соответственно юзать это все можно так:
На сервере в состоянии:
  tree : =>
    content : $defer : =>
      jobs = _Helper 'jobs/main'
      bids = yield jobs.solve 'pupilGetBids',@req.user.id
      modules = for bid in bids
        @module 'bid_module_name' : bid
      return modules


На клиенте проще

Feel.jobs.server 'pupilChatPush',chat.hash,{
  text : text,
  time : time,
  color : 'yellow'
}
###


class Pupil
  init : =>
    @jobs   = yield _Helper 'jobs/main'
    @redis  = yield _Helper('redis/main').get()
    @db     = yield Main.service 'db'

    @dbBids = yield @db.get 'bids'
    @dbChat = yield @db.get 'chat'
    @dbPupil = yield @db.get 'pupil'
    @io = _Helper 'socket.io/main'
    
    @io.on 'connection',@ioconnection

    
    @rooms = {}
    @chats = {}
    @pupil = {}

    yield @jobs.listen 'pupilGetPupil',@jobPupilGetPupil
    yield @jobs.listen 'pupilGetBids',@jobPupilGetBids

    yield @jobs.client 'pupilChatPush',@jobPupilChatPush
    yield @jobs.client 'pupilUpdateBid',@jobPupilUpdateBid
    yield @jobs.client 'pupilUpdatePupil',@jobPupilUpdatePupil
  
  _getID : (_id)=> new (require('mongodb').ObjectID)(_id)
  ioconnection : (socket)=>
    rname = "uid:#{socket.user.id}"
    unless @rooms[rname]?
      @rooms[rname] ?= @io.io.in rname
      #@rooms[rname].on 'chatPush',@ioChatPush
    socket.join rname
    socket.on 'chatPush', => @ioChatPush socket,arguments...
  ioChatPush : (socket,hash,msg)=> Q.spawn =>
    rname = "uid:#{socket.user.id}"
    yield @jobPupilChatPush socket.user,hash,msg
    console.log 'iochatpush',hash,msg
    @io.io.to(rname).emit('chatPush:'+hash,msg)
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
    unless pupil?.name && pupil?.phone && pupil?.registerTime
      pupil ?= {account:id}
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
    console.log 'jobchatpush',auth,hash,msg
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


