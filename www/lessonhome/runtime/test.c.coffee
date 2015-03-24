


@handler = (obj,name)=>
  console.log 'handled',name
  db= yield @$db.get 'feel-smth'
  return yield _invoke db, 'insert', {name:name}



