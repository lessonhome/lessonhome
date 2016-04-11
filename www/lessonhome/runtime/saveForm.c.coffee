


@handler = ($,name,data)=>
  find = {id:$.user.id,formname:name}
  db= yield $.db.get 'pupil-forms'
  yield _invoke db, 'update', find,{$set:data},{upsert:true}
  return 'ok'




