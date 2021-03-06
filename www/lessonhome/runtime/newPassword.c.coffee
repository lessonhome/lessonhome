


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

    return unless accounts[0]? and accounts[0].valid > Date.now()

  if data?.password?.match /\%/
    data.password = unescape data.password
  else
    data.password = _LZString.decompressFromBase64 data.password

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

  yield $.updateUser()
  yield $.status 'tutor',true
  yield $.form.flush '*',$.req,$.res

  if obj?.session?
    return {status:'success',session:obj.session.hash}
  else
    return {status:'success'}
