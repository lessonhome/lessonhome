
#check = require("./check")

@handler = ($,data)=>
  return unless $.user.admin
  db = yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:comment:data},{upsert:true}
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}
