
#check = require("./check")

@handler = ($,data)=>

  qObj = {}

  for key, value of data
    qObj["education.#{key}"] = value

  return unless $.user.tutor

  db= yield $.db.get 'persons'
  persons = yield _invoke db.find({account:$.user.id},{education:1}), 'toArray'
  education = persons?[0]?.education?
  if education?.push?
    yield _invoke db, 'update',{account:$.user.id},{$unset: {education: {}}},{upsert:true}

  yield _invoke db, 'update',{account:$.user.id},{$set: qObj},{upsert:true}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}
