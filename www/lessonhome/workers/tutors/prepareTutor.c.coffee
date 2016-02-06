class PrepareTutor
  version : "1.0"
  init :=>
    @db = yield Main.service 'db'

    @collect = {
      account: yield @db.get 'accounts'
      person:  yield @db.get 'persons'
      tutor:   yield @db.get 'tutor'
      uploaded: yield @db.get 'uploaded'
    }

    @jobs = yield Main.service 'jobs'
    @redis = yield Main.helper('redis/main').get()
    yield @jobs.listen 'prepareTutorByData', @jobPrepareTutorByData
    yield @jobs.listen 'prepareTutorsById', @jobPrepareTutorById
    yield @jobs.listen 'prepareOldTutors', @jobPrepareOldTutors


  run : =>
    old_version = yield _invoke @redis, 'get', 'prepareVersion'

    unless @version is old_version
      yield _invoke @collect.account, 'update', {}, {$unset: prepare: ""}, {multi: true}
      yield _invoke @redis, 'set', 'prepareVersion', @version

    yield @jobPrepareOldTutors(1000*60*60*24*7)


  jobPrepareTutorById : require './prepareTutor/tutorById'
  jobPrepareTutorByData: (data) => @prepare data
  prepare : require './prepareTutor/prepare'

  jobPrepareOldTutors :  (period) =>
    time = new Date()
    time.setTime(time.getTime() - period)
    accounts  = yield _invoke @collect.account.find({'type.tutor' : true, $or: [{prepare: $exists: false}, {'prepare.date' : $lte: time}]}, {accessTime: 0}), 'toArray'
    console.log 'The number of accounts for preparation:', accounts.length
    if accounts.length
      for acc in accounts when acc.id?
        data = yield @_getById [acc.id], ['tutor', 'person', 'uploaded']
        data = data[0]
        continue unless data
        data['account'] = acc
        old_hash = acc.prepare?.hash
        delete acc['prepare']
        hash = _object_hash(data)

        if hash != old_hash
          data = @prepare data
          acc['prepare'] = {
            hash
            date : new Date()
          }

        yield @_saveData(data)
        yield Q.delay(100)

  _getById : (arr_id, fields) =>
    result = []
    found = {}
    $in = {$in: arr_id}

    for f in fields

      switch f
        when 'account'
          name_id = 'id'
        when 'tutor', 'person', 'uploaded'
          name_id = 'account'
        else continue

      data = yield _invoke @collect[f].find({"#{name_id}": $in}), 'toArray'

      for d in data
        id = d[name_id]
        found[id]?={}

        if f == 'uploaded'
          found[id][f]?=[]
          found[id][f].push d
        else
          found[id][f]=d

    result.push(v) for own f, v of found

    return result

  _saveData : ({account, person, tutor, uploaded}) =>
    if account.id? then yield _invoke @collect.account, 'update', {id : account.id, _id: account._id },  {$set: account}, {$upsert: false}
    if person.account? then yield _invoke @collect.person, 'update', {account : person.account, _id: person._id },  {$set: person}, {$upsert: false}
    if tutor.account? then yield _invoke @collect.tutor, 'update', {account : tutor.account, _id: tutor._id },  {$set: tutor}, {$upsert: false}

    if uploaded? and uploaded.length?
      for u in uploaded when u.account?

        if u._id?
          yield _invoke @collect.uploaded, 'update', {account : u.account, _id: u._id },  {$set: u}, {$upsert: false}
        else
          yield _invoke @collect.uploaded, 'insert', u

module.exports = PrepareTutor