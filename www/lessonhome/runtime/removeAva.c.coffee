

@handler = ($)=>
  db = yield $.db.get 'persons'
  rows = yield _invoke db.find({account:$.user.id},{ava:1}), 'toArray'
  accounts = yield _invoke db.find({account:$.user.id}), 'toArray'
  avatars = accounts[0].avatar
  console.log 'ava'.yellow,rows?[0]?.ava
  if avatars?
    ava = avatars.pop()
  yield _invoke db,'update',{account:$.user.id},{$set:{avatar: avatars}},{upsert:true}
  yield $.form.flush ['person'],$.req,$.res
  return {
    status: 'success'
    removed: ava
  }
  
