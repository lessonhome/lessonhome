

@handler = ($,data)=>
  dbBackcall = yield $.db.get 'backcall'
  dbPersons = yield $.db.get 'persons'
  dbAccounts = yield $.db.get 'accounts'
  dbTutor = yield $.db.get 'tutor'
  bc = yield _invoke dbBackcall.find({time:{$exists:true}}).sort({time:-1}),'toArray'
  backcall = []
  for b in bc
    obj = {}
    obj.id = b.account
    obj.backcall =
      name : b.name
      phone : b.phone
      comment : b.comment
      type : b.type
      time : b.time
    obj.account = yield _invoke dbAccounts.find({id:obj.id}),'toArray'
    obj.person  = yield _invoke dbPersons.find({account:obj.id}),'toArray'
    obj.tutor   = yield _invoke dbTutor.find({account:obj.id}),'toArray'
    obj.account = obj.account?[0] ? {}
    obj.person  = obj.person?[0] ? {}
    obj.tutor   = obj.tutor?[0] ? {}
    backcall.push obj
  return {backcall}



