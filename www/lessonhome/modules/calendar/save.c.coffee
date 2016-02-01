
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{calendar:data.calendar }},{upsert:true}
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}

