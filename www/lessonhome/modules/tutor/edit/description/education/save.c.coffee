
#check = require("./check")

@handler = ($,data)=>
  return unless $.user.tutor
  db= yield $.db.get 'persons'
  unless data?.length?
    return (yield _invoke db.find({account:$.user.id},{education:1}),'toArray')?[0]?.education ? []

  yield _invoke db,'update',{account:$.user.id},{$set:education:data},{upsert:true}


  #persons = yield _invoke db.find({account:$.user.id},{education:1}), 'toArray'
  #education = persons?[0]?.education ? []

  #for key, value of data
  #  education[key] = value

  #yield _invoke db, 'update',{account:$.user.id},{$set: {education: education}},{upsert:true}

  yield $.status 'tutor_prereg_5', true
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}
