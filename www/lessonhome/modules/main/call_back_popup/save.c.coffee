
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'backcall'
  yield _invoke db, 'update',{account:$.user.id},{$set:{backcall:[{name:data.your_name, phone:data.tel_number, comment:data.comments, type:data.type, account:$.user.id}]}},{upsert:true}
  #yield $.status 'tutor_prereg_2',true
  return {status:'success'}