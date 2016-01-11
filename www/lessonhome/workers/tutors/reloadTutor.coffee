




module.exports = (ids)->
  if typeof ids == 'string'
    ids = [ids]

  account = _invoke @dbAccounts .find(id:{$in : ids})   ,'toArray'
  person  = _invoke @dbPersons  .find(account:{$in:ids}),'toArray'
  tutor   = _invoke @dbTutor    .find(account:{$in:ids}),'toArray'
  [account,person,tutor] = yield Q.all [account,person,tutor]
  account [a.id]      = a for a in account
  person  [p.account] = p for p in person
  tutor   [t.account] = t for t in tutor
  
  q = []
  for id in ids
    q.push LoadTutor.apply @,id,account[id],person[id],tutor[id]
  yield Q.all q

LoadTutor = (id,account={},person={},tutor={})-> do Q.async =>
  account = account?[0] ? {}
  person  = person?[0] ? {}
  tutor   = tutor?[0] ? {}
  unless account.id && account.index>0
    yield _invoke @redis,'del','parsedTutor.'+id
    return

  obj = {}
  obj.index = account.index


  yield _invoke @redis,'set', 'parsedTutor.'+id,obj
  
