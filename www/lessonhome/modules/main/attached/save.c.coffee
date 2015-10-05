
check = require("./check")


@handler = ($,data)=>
#  return {status:'success'} unless data.phone
  errs = check.check data
  if errs['phone']? || errs['linked']? then return {status:'failed', errs}
  if errs.correct is false then data = {phone: data['phone'], linked: data['linked']}
  data.account = $.user.id
  data['phone'] = data['phone'].replace /[^\d]/g, ''
  console.log 'save bid'
  db = yield $.db.get 'bids'
  yield _invoke db,'update',{account:$.user.id},{$set:data},{upsert:true}
  return {status:'success'}