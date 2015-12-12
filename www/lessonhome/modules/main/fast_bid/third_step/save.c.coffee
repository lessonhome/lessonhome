

@handler = ($,data)=>
  return {status:'success'} unless data.phone
  data.account = $.user.id
  console.log 'save bid'
  data.time = new Date()
  db = yield $.db.get 'bids'
  yield _invoke db,'update',{account:$.user.id},{$set:data},{upsert:true}
  other.call(@,$,data).done()
  return {status:'success'}





  ###
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{location:{full_address:data.your_address}}},{upsert:true}


  db= yield $.db.get 'pupil'
  arr = yield _invoke db.find({account:$.user.id}),'toArray'
  pupil = arr?[0]
  pupil ?= {}
  pupil.bids ?= []
  lastBid = pupil.bids[pupil.bids.length-1]
  unless lastBid?.complited == false
    lastBid = {complited : false}
    pupil.bids.push lastBid
  lastBid.subjects ?= {}
  lastBid.subjects[0] ?= {}
  lastBid.subjects[0].place     = data.place
  lastBid.subjects[0].road_time = data.time_spend_way
  lastBid.subjects[0].calendar  = data.calendar
  lastBid.subjects[0].lesson_duration ?= []
  lastBid.subjects[0].lesson_duration = data.lesson_duration

  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}

  yield $.status 'fast_bid',4
  yield $.form.flush ['person','pupil', 'account'],$.req,$.res
  return {status:'success'}
  ###












