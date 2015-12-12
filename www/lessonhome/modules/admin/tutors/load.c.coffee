

class Admin
  constructor : ->
    $W @
  init : =>
    @ltime = 0
    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()
    try
      @obj = JSON.parse yield _invoke @redis, 'get','adminTutors'
    catch e
      @obj = undefined
      console.error e
    Q.spawn => yield @reload()
    setInterval =>
      Q.spawn => yield @reload()
    ,15*60*1000
  handler : ($,data)=>
    if data?.fast
      return @obj if @obj
    return @obj if @obj && (new Date().getTime()-@ltime)<15*1000
    yield @reload $,data
    return @obj
  reload : =>
    [dbBackcall,dbPersons,dbAccounts,dbTutor,dbBids] = yield Q.all [
      @$db.get 'backcall'
      @$db.get 'persons'
      @$db.get 'accounts'
      @$db.get 'tutor'
      @$db.get 'bids'
    ]
    backcall = null
    accounts = null
    bytime   = null
    nosubject = null
    bids      = null
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
        nophotos = yield _invoke dbPersons.find({hidden:{$ne:true},'avatar.0':{$exists:false}},{avatar:1,account:1,first_name:1,middle_name:1,last_name:1,email:1,phone:1}),'toArray'

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
      do Q.async =>
        accs = yield _invoke dbAccounts.find({login:{$exists:true}},{id:1,login:1,index:1}).sort({registerTime:-1}),'toArray'
        newaccs = {}
        for a in accs
          newaccs[a.id] = a
        nosubject = yield _invoke dbTutor.find({'subjects.0.name':{$exists:true}},{account:1}),'toArray'
        for a in nosubject
          delete newaccs[a.account]
        nosubject = newaccs
      do Q.async =>
        bids = yield _invoke dbBids.find({time:{$exists:true}}).sort({time:-1}),'toArray'
    ]
    @obj = {backcall,nophotos:accounts,time:bytime,nosubject:nosubject,bids:bids}
    Q.spawn =>
      yield _invoke @redis,'set','adminTutors',JSON.stringify @obj
    @ltime = new Date().getTime()
    return @obj

module.exports = new Admin
