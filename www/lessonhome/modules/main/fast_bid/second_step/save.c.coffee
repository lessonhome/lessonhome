
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  lesson_price = []
  lesson_price.push data.price_slider_bids.left
  lesson_price.push data.price_slider_bids.right

  db= yield $.db.get 'pupil'
  yield _invoke db, 'update',{account:$.user.id},{$set:{status:data.pupil_status, 'subjects.0.course':data.course, 'subjects.0.knowledge':data.knowledge_level, 'subjects.0.lesson_price':lesson_price, 'subjects.0.goal':data.goal}},{upsert:true}

  yield $.status 'fast_bid',3
  yield $.form.flush ['pupil', 'account'],$.req,$.res
  return {status:'success'}
