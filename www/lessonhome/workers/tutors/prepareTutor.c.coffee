class PrepareTutor
  version : "1"
  init :=>
    @db = yield Main.service 'db'
    @account = yield @db.get 'accounts'
    @persons = yield @db.get 'persons'
    @tutor = yield @db.get 'tutor'
    @uploaded = yield @db.get 'uploaded'
    @redis = yield Main.helper('redis/main').get()

  run : =>
    old_version = yield _invoke @redis, 'get', 'prepareVersion'

    unless @version is old_version
      yield _invoke @account, 'update', {}, {$unset: prepare: ""}
      yield _invoke @redis, 'set', 'prepareVersion', @version

    now = new Date()
    accounts  = yield _invoke @account.find({'type.tutor' : true, $or: [{prepare: $exists: false}, {'prepare.date' : $lte: now}]}, {_id: 0, registerTime: 0, sessions: 0, accessTime: 0, authToken: 0}), 'toArray'
    if accounts.length
      for acc in accounts when acc.id?
        person = yield _invoke @persons.find({account: acc.id}, {_id: 0}), 'toArray'
        tutor = yield _invoke @tutor.find({account: acc.id}, {_id: 0}), 'toArray'
        data = {
          account: acc
          person: person[0] ? {}
          tutor: tutor[0] ? {}
        }
        old_hash = acc.prepare?.hash
        delete acc['prepare']
        hash = _object_hash(data)
        if old_hash? and hash != old_hash
          now.setDate(now.getDate + 7)
          data = @prepare data
          acc['prepare'] = {
            hash
            date : now
          }
          console.log 'data= ', data
#          yield _invoke @accounts, 'update', {id: acc.id}, {$set: data.account}, {$upset: true}
#          yield _invoke @persons, 'update', {account: acc.id}, {$set: data.person}, {$upset: true}
#          yield _invoke @tutor, 'update', {account: acc.id}, {$set: data.tutor}, {$upset: true}
          Q.delay(100)


  jobPrepare: (data) =>

  prepare : require './prepareTutor/prepare'

module.exports = PrepareTutor