

#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'tutor'
  #yield _invoke db, 'update',{account:$.user.id},{$set:{}},{upsert:true}

  return {status:'success'}