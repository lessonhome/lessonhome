

@handler = ($)=>
  db = yield $.db.get 'persons'
  rows = yield _invoke db.find({account:$.user.id},{ava:1}), 'toArray'
  accounts = yield _invoke db.find({account:$.user.id}), 'toArray'
  photos = accounts[0].photos
  avatar = accounts[0].avatar
  uploaded = accounts[0].uploaded
  delete uploaded[avatar]
  if photos
    photos.pop()
    if !photos[0]?
      avatar = ''
    else
      avatar = photos[photos.length-1]
    yield _invoke db,'update',{account:$.user.id},{$set:{photos:photos, avatar: avatar, uploaded : uploaded}},{upsert:true}
  if rows?[0]?.ava?[0]?
    rows[0].ava.pop()
    yield _invoke db,'update',{account:$.user.id},{$set:{ava:rows[0].ava}},{upsert:true}
  yield $.form.flush ['person'],$.req,$.res
  return {status:'success'}
  
