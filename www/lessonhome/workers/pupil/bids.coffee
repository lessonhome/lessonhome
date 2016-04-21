
Bid = require './bid'

GLO = {}

class Bids
  constructor : (@main)->
    $W @
    @locker = $Locker()
    @bids   = {}
    @toMerge= []

  ###########################################################
  init : => @locker.$lock =>
    yield @reloadDb()

  run : => @locker.$free =>
    yield @runMerge()

  getBid : (userId,bidIndex)=> @locker.$free =>
    throw new Error "unknown bid #{userId}:#{bidIndex}" unless @bids.account[userId]?[bidIndex]?
    return @bids.account[userId][bidIndex]

  getUserBids : (userId)=> @locker.$free =>
    bids = []
    for index,bid of (@bids?.account?[userId] ? {})
      bids.push bid.getData()
    bids = yield Q.all bids
    bids.sort (a,b)=> a.time.getTime()-b.time.getTime()
    return bids
  
  bidUpdate : (auth,index,data)=> @locker.$free =>
    throw new Error "unknown user #{auth?.id}" unless @bids.account?[auth.id]?
    bid = yield @getBid auth.id,index
    yield bid.update data

  updatedPupil : (pupil)=> @locker.$async =>
    f = account:$in:pupil.accounts
    yield _invoke @main.dbBids,'update',f,{$set:account:pupil.account},{multi:true}
    yield @reloadDb()
    
  ########################################################### 
  reloadDb : =>
    db = yield _invoke @main.dbBids.find({}).sort(time:1),'toArray'
    db ?= []
    @toMerge = []
    for index,bid of (@bids?.index ? {})
      yield bid.destruct()
    @bids = {index:{},account:{}}
    for dbbid in db
      unless dbbid.state
        @toMerge.push dbbid
        continue
      yield @initBid dbbid
  initBid : (dbbid)=>
    bid = new Bid @main
    yield bid.init dbbid
    @bids.index[bid.data.index] = bid
    @bids.account[bid.data.account] ?= {}
    @bids.account[bid.data.account][bid.data.index] = bid
    pupil = yield @main.pupils.getPupil bid.data.account
    #console.log "pupil",bid.data.account,pupil.data.account
  runMerge : =>
    for dbbid in @toMerge
      yield @bidMerge dbbid
    @toMerge = []
    console.log GLO

  bidMerge : (dbbid)=>
    unless dbbid.account
      return yield @removeBid dbbid
    _oldId = dbbid._id
    dbpupil = Bid::_extractPupil dbbid
    pupil = yield @main.pupils.mergePupilInfo dbpupil
    pupildata  = yield pupil.getData()
    dbbid.account = pupildata.account
    #bid   = Bid::_prepareBid dbbid
    if dbbid?.id && dbbid?.comments?
      yield @bidMergeMessage dbbid
      #yield @removeBid dbbid
    else
      yield @bidMergeRegular dbbid
  bidMergeRegular : (bid)=>
    for key,val of bid
      GLO[key]= val
    if bid.subjects
      subjects = {}
      for key,val of bid.subjects
        if bid.subjects.length then  subjects[val] = true
        else  subjects[key] = true
    #console.log bid
    fo = account:bid.account
    fo.subjects = $in : [bid.subject] if bid.subject

  bidMergeMessage : (bid)=>
    return
    console.log bid
    fo = account:bid.account
    fo.subjects = $in : [bid.subject] if bid.subject
    found = yield @findLast fo
    if found
      found = @bids.account[found.account]?[found.index]
      throw new Error 'bad found bid' unless found
      yield found.update
        subject : bid.subject
        linked  : bid.linked
      yield found.linkTutorMessage {tutorIndex:bid.id,message:bid.comments}
    else
      found = yield @bidNewFromMessage bid
    console.log found.data,"\n"
    return found

  bidNewFromMessage : (dbbid)=>
    b =
      account : dbbid.account
      subject : dbbid.subject
      time    : dbbid.time
      linked  : dbbid.linked
    bid = new Bid @main
    yield bid.init b
    @bids.account[bid.data.account] ?= {}
    @bids.account[bid.data.account][bid.data.index] = bid
    @bids.index[bid.data.index] = bid

    yield bid.linkTutorMessage {tutorIndex:dbbid.id,message:dbbid.comments}
    return bid

  findLast : (find)=>
    find.state = 'in_work'
    bid = yield _invoke @main.dbBids.find(find).sort(time:-1).limit(1),'toArray'
    return bid?[0]

  removeBid : (bid)=>
    return unless bid._id
    yield _invoke @main.dbBids,'remove',{_id:@main._getID(bid._id)}
  

module.exports = Bids


