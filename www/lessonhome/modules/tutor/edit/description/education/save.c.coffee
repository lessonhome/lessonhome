
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{education:{country:data.country, city:data.city, name:data.university, faculty:data.faculty, chair:data.chair, qualification:data.status }}},{upsert:true}

  return {status:'success'}
