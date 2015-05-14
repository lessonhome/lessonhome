
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{first_name:data.name, email:[data.email] }},{upsert:true}

  db= yield $.db.get 'pupil'

  arr = yield _invoke db.find({account:$.user.id}),'toArray' #{bids:{$elemMatch:{complited:false}}}),'toArray'
  pupil = arr?[0]
  console.log pupil
  pupil ?= {}
  pupil.bids ?= []
  lastBid = pupil.bids[pupil.bids.length-1]
  unless lastBid?.complited == false
    lastBid = {complited : false}
    pupil.bids.push lastBid
  lastBid.phone_call ?= {}
  lastBid.phone_call.phones ?= [data.phone]
  lastBid.phone_call.phones[0] = data.phone
  lastBid.subjects ?= {}
  lastBid.subjects
  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}
  console.log pupil
  #{bids:[{phone_call:{phones:[data.phone], description:data.call_time}, 'subjects.0.subject':data.subject, 'subjects.0.comments':data.comments}]}},{upsert:true}
  console.log yield _invoke db.find({account:$.user.id},{bids:{$elemMatch:{complited:false}}}),'toArray'

  yield $.status 'fast_bid',2
  yield $.form.flush ['person','pupil', 'account'],$.req,$.res
  return {status:'success'}





