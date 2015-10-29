


@handler = ($, data)->
  return {status:'failed',err:'login_not_exists'} unless data?.login?.length > 2

  db = yield Main.service 'db'
  accountsDb = yield db.get 'accounts'
  personsDb = yield db.get 'persons'
  
  accounts = yield _invoke accountsDb.find({'login': data.login}),'toArray'
  if accounts[0]?
    data.id = accounts[0].id
    persons = yield _invoke personsDb.find({account:accounts[0].id},{phone:1,email:1}),'toArray'
    persons?[accounts[0].id] = persons?[0]
    accountFound = true
  unless accounts[0]? && persons?[data?.id]?.email?[0]
    persons = yield _invoke personsDb.find({$or:[{'phone.0':{$exists:true}},{'email.0':{$exists:true}}]},{phone:1,email:1,account:1}),'toArray'
    accs = []
    for p in persons
      str = ''
      str += (p.phone ? []).join(';').replace(/[^\d\;]/gmi,'') ? ''
      str += (p.email ? []).join(';') ? ''
      if str.match data.login
        accountFound = true
        accs.push p.account
        p.str = str
        persons[p.account] = p
    accounts = yield _invoke accountsDb.find({id:{$in:accs}},{id:1,accessTime:1,login:1}).sort({accessTime:-1}),'toArray'
    ok = false
    for a in accounts
      str = a.login+';'+persons[a.id].str+';'
      continue unless str.match /\@/
      ok = true
      data.login = a.login
      data.id    = a.id
    unless ok
      return {status:'failed',err:'login_not_exists'} unless accountFound
      return {status:'failed',err:'email_not_exists'}

  
  data.phone = []
  data.email = []
  if data.login.match /\@/
    data.email.push data.login
    data.email[data.login] = true
  else
    data.phone.push data.login
    data.phone[data.login] = true
  return {status:'failed',err:'login_not_exists'} unless data?.id
  
  unless persons?[data.id]?
    persons = yield _invoke personsDb.find({account:data.id},{phone:1,email:1}),'toArray'
    persons?[data.id] = persons?[0]
  
  for e in persons?[data.id]?.email ? []
    if e?.match?(/\@/) && (e.length > 3)
      unless data.email[e]
        data.email.push e
        data.email[e]=true
  for e in persons?[data.id]?.phone ? []
    e = e?.replace?(/\D/gmi,'') || ''
    if e && !data.phone[e]
      data.phone.push e
      data.phone[e] = true
  return {status:'failed',err:'email_not_exists'} unless data.email.length

  try
    yield $.register.passwordRestore data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:'login_not_exists'}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}
