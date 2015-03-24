


@handler = (name,data)=>
  find = {id:10,formname:name}
  db= yield @$db.get 'pupil-forms'
  yield _invoke db, 'update', find,{$set:data},{upsert:true}
  console.log 'saved',name
  return 'ok'




