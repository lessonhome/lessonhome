
#check = require("./check")

@handler = ($,data)=>
  db = yield $.db.get 'persons'
  unless data?.reviews?
    p = yield _invoke db.find({account:$.user.id},{reviews:1}),'toArray'
    return p?[0]?.reviews ? []
  yield _invoke db, 'update',{account:$.user.id},{$set:reviews:data.reviews},{upsert:true}
  return {status:'success'}








  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{work:data.work}},{upsert:true}

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{experience:data.experience, extra:[{type:'text',text:data.extra_info}]}},{upsert:true}
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}
