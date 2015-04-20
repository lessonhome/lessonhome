
@get =(field)=>
  db= yield @$db.get 'persons'
  rows = yield _invoke db.find({account:@$user.id},{"#{field}":1}), 'toArray'
  rows ?= []
  rows[0] ?= {}
  return rows[0]?[field] ?= ""


@getAll =()=>
  db= yield @$db.get 'persons'
  rows= yield _invoke db.find({account:@$user.id}), 'toArray'
  rows ?= []
  rows[0] ?= {}
  return rows[0]