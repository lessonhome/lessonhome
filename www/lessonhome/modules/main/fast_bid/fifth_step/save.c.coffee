
@handler = ($)=>

  db= yield $.db.get 'pupil'
  arr = yield _invoke db.find({account:$.user.id}),'toArray'
  pupil = arr?[0]
  pupil ?= {}
  pupil.bids ?= []
  lastBid = pupil.bids[pupil.bids.length-1]
  unless lastBid?.complited == false
    lastBid = {complited : false}
    pupil.bids.push lastBid
  lastBid.complited = true 
  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}

  yield $.status 'fast_bid',5
  yield $.form.flush ['pupil', 'account'],$.req,$.res
  return {status:'success'}


