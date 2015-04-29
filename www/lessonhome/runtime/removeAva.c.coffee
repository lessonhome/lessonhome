

@handler = ($)=>
  db = yield $.db.get 'persons'
  rows = yield _invoke db.find({account:$.user.id},{ava:1}), 'toArray'
  console.log 'ava'.yellow,rows?[0]?.ava
  if rows?[0]?.ava?[0]?
    rows[0].ava.pop()
    yield _invoke db,'update',{account:$.user.id},{$set:{ava:rows[0].ava}},{upsert:true}
  console.log 'ava'.yellow, rows?[0]?.ava
  return {status:'success'}
  
