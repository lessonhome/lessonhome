
#check = require("./check")

@handler = ($,data)=>
  return unless $.user.admin
  p = yield $.db.get 'persons'
  a = yield $.db.get 'accounts'
  s = yield $.db.get 'sessions'
  t = yield $.db.get 'tutor'
  u = yield $.db.get 'uploaded'
  yield _invoke p, 'remove', {account:$.user.id}
  yield _invoke a, 'remove', {id:$.user.id}
  yield _invoke s, 'remove', {account:$.user.id}
  yield _invoke t, 'remove', {account:$.user.id}
  yield _invoke u, 'remove', {account:$.user.id}
  yield $.register.delete_tutor $.user.id
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}

