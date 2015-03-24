


@main = (o)=>
  console.log @$user
  @db = yield @$db.get 'feel-smth'
  yield _invoke @db.find(), 'toArray'

  

  
