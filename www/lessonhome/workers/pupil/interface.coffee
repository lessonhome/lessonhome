




class Interface
  constructor : (@main)->
    $W @
    @locker = $Locker()

  ##########################################################
  init : => @locker.$lock =>
    yield @main.jobs.listen 'pupilGetPupil',(userId)=> do Q.async =>
      pupil = yield @main.pupils.getPupil(userId)
      return yield pupil.getData()
    yield @main.jobs.listen 'pupilGetBids', (userId)=> do Q.async =>
      bids = yield @main.bids.getUserBids(userId)
      return bids

    yield @main.jobs.client 'pupilChatPush',(auth,hash,msg)=> @main.chats.msgPush auth,hash,msg
    yield @main.jobs.client 'pupilUpdateBid',(auth,index,data)=> @main.bids.bidUpdate auth,index,dat
    yield @main.jobs.client 'pupilUpdatePupil',(auth,data)=> @main.pupils.pupilUpdate auth,data

    yield @main.jobs.client 'pupilSaveBid',(auth,data)=> @main.bids.bidSave auth,data
   
    @main.io.on 'connect', @ioConnect

  run : => @locker.$lock =>

  ##########################################################
  ioConnect : (socket)=> Q.spawn =>
    socket.on 'chatPush', (hash,msg)=> Q.spawn =>
      yield @main.chats.msgPush socket.user,hash,msg
    

module.exports = Interface




