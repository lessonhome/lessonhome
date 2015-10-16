


@handler = ($,data)->
  #$.req.udata.onceAuth.hash
  if data.password.match /\%/
    data.password = unescape data.password
  else
    data.password = _LZString.decompressFromBase64 data.password

  data.type = 'tutor'
  try
    yield $.register.newType $.user,$.session,data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  @delayRegisterMail($.user.id).done()

  return {status:'success'}




@delayRegisterMail = (id)->

  yield Q.delay 1000*60*10

  db = yield Main.service 'db'
  mail = yield Main.service 'mail'

  personsDb = yield db.get 'persons'
  accountsDb = yield db.get 'accounts'

  persons = yield  _invoke personsDb.find({account: id}), 'toArray'
  accounts = yield _invoke accountsDb.find({id:id},{login:1}),'toArray'
  p = persons?[0] ? {}
  name = "#{p?.last_name ? ''} #{p?.first_name ? ''} #{p?.middle_name ? ''}"
  name = name.replace /^\s+/,''
  name = name.replace /\s+$/,''
  name = ', '+ name if name
  return unless accounts[0].login.match '@'
  yield mail.send(
    'register.html'
    accounts[0].login
    'Спасибо за регистрацию'
    {
      name: name
      login: accounts[0].login
    }
  )
