

@handler = ($, data)=>


  db = yield Main.service 'db'
  personsDb = yield db.get 'persons'

  persons = yield _invoke personsDb.find({account: $.user.id}),'toArray'
  avatars = persons[0].avatar
  photos = persons[0].photos

  if photos.indexOf(data.hash) != -1
    photos.splice photos.indexOf(data.hash), 1

  yield _invoke(personsDb,'update', {account: $.user.id},{$set:{photos: photos}},{upsert:true})

  yield $.updateUser()
  yield $.form.flush '*',$.req,$.res

  console.log 'remove media', data
  return {status:'success'}
  
