
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{first_name:data.name, email:[data.email] }},{upsert:true}

  db= yield $.db.get 'pupil'
  yield _invoke db, 'update',{account:$.user.id},{$set:{phone_call:{phones:[data.phone], description:data.call_time}, 'subjects.0.subject':data.subject, 'subjects.0.comments':data.comments}},{upsert:true}

  yield $.form.flush ['pupil','persons'],$.req,$.res
  return {status:'success'}