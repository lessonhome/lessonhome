
Bid = require './bid'

GLO = {}

class Bids
  constructor : (@main)->
  init : =>
    yield @reloadDb()
  
  reloadDb : =>
    db = yield _invoke @main.dbBids.find({}).sort(time:1),'toArray'
    db ?= []
    bids = {index:{},account:{}}
    toMerge = []
    for dbbid in db
      unless dbbid.state
        toMerge.push dbbid
        continue
      bid = new Bid @main
      yield bid.init dbbid
      bids.index[bid.data.index] = bid
      bids.account[bid.data.account]?= {}
      bids.account[bid.data.account][bid.data.index] = bid
    for dbbid in toMerge
      yield @bidMerge dbbid
    console.log GLO
    @bids = bids
  getBid : (userId,bidIndex)=>
    throw new Error "unknown bid #{userId}:#{bidIndex}" unless @bids.account[userId]?[bidIndex]?
    return @bids.account[userId][bidIndex]
  getUserBids : (userId)=>
    bids = []
    for index,bid of (@bids?.account?[userId] ? {})
      bids.push bid.getData()
    bids = yield Q.all bids
    bids.sort (a,b)=> a.time.getTime()-b.time.getTime()
    return bids
  bidUpdate : (auth,index,data)=>
    throw new Error "unknown user #{auth?.id}" unless @bids.account?[auth.id]?
    bid = yield @getBid auth.id,index
    yield bid.update data

  bidMerge : (bid)=>
    unless bid.account
      return yield @removeBid bid
    if bid?.id && bid?.comments?
      yield @bidMergeMessage bid
      #yield @removeBid bid

  bidMergeMessage : (bid)=>
    for key,val of bid
      GLO[key] = val

    fo = account:bid.account
    fo.subjects = $in : [bid.subject] if bid.subject
    found = yield @findLast fo
    if found
      found = yield @bids.getBid found.account,found.index
      yield found.update
        subject : bid.subject
        name    : bid.name
        phone   : bid.phone
        email   : bid.email
        linked  : bid.linked
    else
      found = yield @bidNewFromMessage bid

    

  bidNewFromMessage : (dbbid)=>
    b =
      account : dbbid.account
      subject : dbbid.subject
      time    : dbbid.time
      name    : dbbid.name
      phone   : dbbid.phone
      linked  : dbbid.linked
      email   : dbbid.email
    bid = new Bid @main
    yield bid.init b
    
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


