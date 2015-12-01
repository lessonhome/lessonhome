
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  #return {status:'failed'} unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}
  db= yield $.db.get 'backcall'
  yield _invoke db, 'update',{account:$.user.id},{$set:{
    name    : check.getText(data.your_name)
    phone   : check.getPhone(data.tel_number)
    comment : check.getText(data.comments)
    type    : check.getText(data.type)
    account : $.user.id
    time    : new Date()
  }},{upsert:true}
  #yield $.status 'tutor_prereg_2',true
  #yield $.form.flush ['tutor','person','account'],$.req,$.res
  return {status:'success'}
