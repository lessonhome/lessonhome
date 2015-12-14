

@handler = ($, data)=>

  result = {status: 'success'}
  personsDb = yield $.db.get 'persons'
  uploadedDb = yield $.db.get 'uploaded'
  acc = yield _invoke personsDb.find({account:$.user.id},{avatar:1}), 'toArray'
  uploaded = yield _invoke uploadedDb.find({hash : data.id+'high'}), 'toArray'
  avatars = acc?[0]?.avatar ? []
  uploaded = uploaded?[0] ? {}

  if avatars.indexOf(data.id) != -1
    avatars.splice(avatars.indexOf(data.id), 1)
  avatars.push data.id
  result.newAva = {
    url : uploaded.url
    height : uploaded.height
    width : uploaded.width
  }

  yield _invoke personsDb,'update',{account:$.user.id},{$set:{avatar: avatars}},{upsert:true}

  yield $.form.flush '*',$.req,$.res

  return result
