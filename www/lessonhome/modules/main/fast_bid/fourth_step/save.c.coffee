
#check = require("./check")

@handler = ($,data)=>
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  age = []
  age.push data.age_slider.left
  age.push data.age_slider.right

  requirements_for_tutor = {}
  requirements_for_tutor.status = data.status
  requirements_for_tutor.experience = data.experience
  requirements_for_tutor.sex = data.sex
  requirements_for_tutor.age = age


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
  lastBid.subjects[0].requirements_for_tutor = requirements_for_tutor
  yield _invoke db, 'update',{account:$.user.id},{$set:pupil},{upsert:true}

  yield $.status 'fast_bid',5
  yield $.form.flush ['pupil', 'account'],$.req,$.res
  return {status:'success'}


