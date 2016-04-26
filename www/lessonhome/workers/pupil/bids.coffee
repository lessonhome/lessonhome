
Bid = require './bid'


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
      bids.push bid.getExtraData()
    bids = yield Q.all bids
    bids.sort (a,b)=> b.bid.time.getTime()-a.bid.time.getTime()
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
    #@bids.index[bid.data.index] = bid
    #@bids.account[bid.data.account] ?= {}
    #@bids.account[bid.data.account][bid.data.index] = bid
    pupil = yield @main.pupils.getPupil bid.data.account
    #console.log "pupil",bid.data.account,pupil.data.account
    return bid
  runMerge : =>
    for dbbid in @toMerge
      yield @bidMerge dbbid
    @toMerge = []

  bidMerge : (dbbid)=>
    unless dbbid.account
      return yield @removeBid dbbid
    _oldId = dbbid._id
    _oldIndex = dbbid.index
    dbpupil = Bid::_extractPupil dbbid
    pupil = yield @main.pupils.mergePupilInfo dbpupil
    pupildata  = yield pupil.getData()
    dbbid.account = pupildata.account
    delete dbbid._id
    #bid   = Bid::_prepareBid dbbid
    ret = []
    if dbbid?.id && dbbid?.comments?
      ret.push (yield @bidMergeMessage dbbid)...
    else
      ret.push (yield @bidMergeRegular dbbid)...
    if _oldId || _oldIndex
      for bid in ret
        return if _oldIndex && (bid.data.index == _oldIndex)
        return if _oldId && (bid.data._id == _oldId)
      yield @removeBidIdIndex _oldId,_oldIndex
    return
  bidMergeRegular : (bid)=>
    if bid.subjects
      subjects = {}
      for key,val of bid.subjects
        if bid.subjects.length then  subjects[val] = true
        else  subjects[key] = true
      subjects[bid.subject] = true if bid.subject
      for key of subjects
        ret = []
        nbid = Object.assign {},bid,{subject:key}
        delete nbid.subjects
        ret.push (yield @bidMergeRegular nbid)...
      return ret

    fo = account:bid.account
    fo.subjects = $in : [bid.subject] if bid.subject
    found = yield @findLast fo
    if found
      f2 = found
      found = @bids.account[found.account]?[found.index]
      unless found
        console.log f2
        console.log @bids.account[f2.account]
        throw new Error 'bad found bid regular'
      yield found.update bid
    else
      found = yield @initBid bid
    return [found]

  bidMergeMessage : (bid)=>
    fo = account:bid.account
    fo.subjects = $in : [bid.subject] if bid.subject
    found = yield @findLast fo
    if found
      f2 = found
      found = @bids.account[found.account]?[found.index]
      #throw new Error 'bad found bid' unless found
      unless found
        console.log f2
        console.log @bids.account[f2.account]
        throw new Error 'bad found bid message'
      yield found.update
        subject : bid.subject
        linked  : bid.linked
      yield found.linkTutorMessage {tutorIndex:bid.id,message:bid.comments}
    else
      found = yield @bidNewFromMessage bid
    return [found]

  bidNewFromMessage : (dbbid)=>
    b =
      account : dbbid.account
      subject : dbbid.subject
      time    : dbbid.time
      linked  : dbbid.linked
    bid = new Bid @main
    yield bid.init b
    #@bids.account[bid.data.account] ?= {}
    #@bids.account[bid.data.account][bid.data.index] = bid
    #@bids.index[bid.data.index] = bid

    yield bid.linkTutorMessage {tutorIndex:dbbid.id,message:dbbid.comments}
    return bid

  findLast : (find)=>
    find.state = 'active'
    bid = yield _invoke @main.dbBids.find(find).sort(time:-1).limit(1),'toArray'
    return bid?[0]

  removeBid : (bid)=>
    return unless bid._id
    yield _invoke @main.dbBids,'remove',{_id:@main._getID(bid._id)}
  removeBidIdIndex : (id,index)=>
    fo = {}
    fo._id = @main._getID id if id
    fo.index = index if index
    fo.state = $exists : false
    return unless id || index
    yield _invoke @main.dbBids,'remove',fo,{multi:true}

module.exports = Bids


