
#check = require("./check")

@handler = ($,data,quiet=false)=>
  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  unless data?.work?
    return (yield _invoke db.find({account:$.user.id},{work:1}),'toArray')?[0]?.work ? []

  yield _invoke db, 'update',{account:$.user.id},{$set:{work:data.work}},{upsert:true}
  if quiet
    yield $.form.flush '*',$.req,$.res
    return {status:'success'}
  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{experience:data.experience, extra:[{type:'text',text:data.extra_info}]}},{upsert:true}
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}
