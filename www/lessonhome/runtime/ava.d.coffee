

@get = (all=false)=>
  db = yield @$db.get 'persons'
  rows = yield _invoke db.find({account:@$user.id},{ava:{$slice:-1}}), 'toArray'
  unless all
    return rows?[0]?.ava?[0]
  return rows?[0]?.ava
  
