
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{phone_call:{description:data.callback_comment}, settings:{new_orders:data.new_orders, get_notifications:data.get_notifications, call_operator_possibility:data.call_operator_possibility }}},{upsert:true}

  return {status:'success'}
