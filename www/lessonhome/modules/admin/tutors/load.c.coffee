

@handler = ($,data)=>
  [dbBackcall,dbPersons,dbAccounts,dbTutor] = yield Q.all [
    $.db.get 'backcall'
    $.db.get 'persons'
    $.db.get 'accounts'
    $.db.get 'tutor'
  ]
  backcall = null
  accounts = null
  bytime   = null
  yield Q.all [
    do Q.async =>
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
    do Q.async =>
      nophotos = yield _invoke dbPersons.find({hidden:{$ne:true},'ava.0':{$exists:false}},{ava:1,account:1,first_name:1,middle_name:1,last_name:1,email:1,phone:1}),'toArray'

      accs = []
      for p in nophotos
        accs.push p.account
        nophotos[p.account] = p
      accounts = yield _invoke dbAccounts.find({id:{$in:accs}},{id:1,login:true,index:1}).sort({registerTime:-1}),'toArray'
      for a in accounts
        p = nophotos[a.id]
        a[key] = val for key,val of p
    do Q.async =>
      bytime = yield _invoke dbAccounts.find({login:{$exists:true}},{id:1,accessTime:1,login:1,index:1}
      ).sort({accessTime:-1}).limit(100),'toArray'
      for a in bytime
        a.person = _invoke dbPersons.find({account:a.id}),'toArray'
      for a in bytime
        a.person = (yield a.person)?[0] ? {}
  ]
  return {backcall,nophotos:accounts,time:bytime}



