
#check = require("./check")

@handler = ($,data)=>
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  lesson_price = []
  lesson_price.push data.price_slider_bids.left
  lesson_price.push data.price_slider_bids.right

  #db= yield $.db.get 'pupil'
  #yield _invoke db, 'update',{account:$.user.id},{$set:{status:data.pupil_status, 'subjects.0.course':data.course, 'subjects.0.knowledge':data.knowledge_level, 'subjects.0.lesson_price':lesson_price, 'subjects.0.goal':data.goal}},{upsert:true}

  db= yield $.db.get 'pupil'
  arr = yield _invoke db.find({account:$.user.id}),'toArray' #{bids:{$elemMatch:{complited:false}}}),'toArray'
  pupil = arr?[0]
  pupil ?= {}
  pupil.bids ?= []
  lastBid = pupil.bids[pupil.bids.length-1]
  unless lastBid?.complited == false
    lastBid = {complited : false}
    pupil.bids.push lastBid


  lastBid.status = data.pupil_status
  lastBid.subjects ?= {}
  lastBid.subjects[0] ?= {}
  lastBid.subjects[0].course  = data.course
  lastBid.subjects[0].knowledge  = data.knowledge_level
  lastBid.subjects[0].lesson_price = lesson_price
  lastBid.subjects[0].goal = data.goal

  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}


  yield $.status 'fast_bid',3
  yield $.form.flush ['pupil', 'account'],$.req,$.res
  return {status:'success'}
