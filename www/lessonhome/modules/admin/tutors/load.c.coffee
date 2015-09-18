

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
    obj.account =  _invoke dbAccounts.find({id:obj.id}),'toArray'
    obj.person  =  _invoke dbPersons.find({account:obj.id}),'toArray'
    obj.tutor   =  _invoke dbTutor.find({account:obj.id}),'toArray'
    backcall.push obj

  for obj in backcall
    obj.account = (yield obj.account)?[0] ? {}
    obj.person  = (yield obj.person)?[0] ? {}
    obj.tutor   = (yield obj.tutor)?[0] ? {}
  return {backcall}



