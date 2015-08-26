


@handler = ($, data)->

  data.ref = $.req.headers.referer

  if data.check

    db = yield Main.service 'db'
    urldata = yield Main.service 'urldata'
    accountsDb = yield db.get 'accounts'

    qstring = data.ref.replace(/.*\?/, '')
    token = yield urldata.u2d qstring
    token = token.authToken.token

    accounts = yield _invoke accountsDb.find({'authToken.token': token}),'toArray'

    return accounts[0]?.authToken.valid < Date.now()


  try
    obj = yield $.register.newPassword $.user, data

    if obj.redirect
      return {status: 'redirect'}
    if obj?.session?
      $.cookie.set 'session'
      $.cookie.set 'session',obj.session.hash
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}

  if obj?.session?
    yield $.updateUser()
    yield $.status 'tutor',true
    yield $.form.flush '*',$.req,$.res
    return {status:'success',session:obj.session.hash}
  else
    yield $.form.flush '*',$.req,$.res
    return {status:'success'}