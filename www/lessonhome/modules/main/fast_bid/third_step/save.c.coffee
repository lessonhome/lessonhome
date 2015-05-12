
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{location:{full_address:data.your_address}}},{upsert:true}

  db= yield $.db.get 'pupil'
  yield _invoke db, 'update',{account:$.user.id},{$set:{'subjects.0.place':data.place, 'subjects.0.road_time':data.time_spend_way, 'subjects.0.calendar':data.calendar, 'subjects.0.lesson_duration':data.lesson_duration}},{upsert:true}

  yield $.form.flush ['person','pupil'],$.req,$.res
  return {status:'success'}
