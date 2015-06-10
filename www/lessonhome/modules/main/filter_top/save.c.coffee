
@handler = ($,data)=>
  console.log data

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
  if data.subject?
    lastBid.subjects[0].subject = data.subject
  if data.place?
    lastBid.subjects[0].place  = data.subject
  if data.lesson_price?
    lastBid.subjects[0].lesson_price = data.lesson_price
  if data.requirements_for_tutor?
    lastBid.requirements_for_tutor ?= {}
    lastBid.requirements_for_tutor.status = data.requirements_for_tutor.status

  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}

  yield $.form.flush ['pupil'],$.req,$.res
  return {status:'success'}


