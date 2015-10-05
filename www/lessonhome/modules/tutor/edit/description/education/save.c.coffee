
#check = require("./check")

@handler = ($,data)=>

  return unless $.user.tutor

  db= yield $.db.get 'persons'
  persons = yield _invoke db.find({account:$.user.id},{education:1}), 'toArray'
  education = persons?[0]?.education ? []

  for key, value of data
    education[key] = value

  yield _invoke db, 'update',{account:$.user.id},{$set: {education: education}},{upsert:true}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}
