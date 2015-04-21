

@get = (all=false)=>
  db = yield @$db.get 'persons'
  rows = yield _invoke db.find({account:@$user.id},{photos:{$slice:-1}}), 'toArray'
  unless all
    return rows?[0]?.photos?[0]
  return rows?[0]?.photos
  
