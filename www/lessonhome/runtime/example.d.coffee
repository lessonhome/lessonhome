


@main = (o)=>
  @db = yield @$db.get 'feel-smth'
  yield _invoke @db.find(), 'toArray'

  

  
