


@handler = ($, data)->
  return {status:'failed',err:'login_not_exists'} unless data?.login?.length > 2

  db = yield Main.service 'db'
  accountsDb = yield db.get 'accounts'

  accounts = yield _invoke accountsDb.find({'login': data.login}),'toArray'
  unless accounts[0]?
    personsDb = yield db.get 'persons'
    persons = yield _invoke personsDb.find({$or:[{'phone.0':{$exists:true}},{'email.0':{$exists:true}}]},{phone:1,email:1,account:1})
    accs = []
    for p in persons
      str = ''
      str += (p.phone ? []).join(';').replace(/[^\d\;]/gmi,'') ? ''
      str += (p.email ? []).join(';') ? ''
      if str.match data.login
        accs.push p.account
        p.str = str
        persons[p.account] = p
    return {status:'failed',err:'login_not_exists'} unless accs.length
    accounts = yield _invoke accountsDb.find({id:{$in:[accs]}},{id:1,accessTime:1,login:1}).sort({accessTime:-1}).limit(1),'toArray'
    return {status:'failed',err:'login_not_exists'} unless accounts[0]?
    str = accounts[0].login+';'+persons[accounts[0].id].str+';'
    email = str.match(/([^\;]+\@[^\;]+)\;/)?[1] || ''
    


  return {status:'failed',err:'login_not_exists'} unless accounts[0]?

  try
    yield $.register.passwordRestore data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}
