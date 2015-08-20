


@handler = ($,data)->
  data.type = 'tutor'
  try
    yield $.register.newType $.user,$.session,data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  @delayRegisterMail($.user.id)

  return {status:'success'}




@delayRegisterMail = (id)->

  yield Q.delay 1000*60*2

  db = yield Main.service 'db'
  mail = yield Main.service 'mail'

  personsDb = yield db.get 'persons'
  accountsDb = yield db.get 'accounts'

  persons = yield  _invoke personsDb.find({account: id}), 'toArray'
  accounts = yield _invoke accountsDb.find({id:id},{login:1}),'toArray'

  if accounts[0].login.match '@'
    mail.send(
      'example.html'
      'arsereb@gmail.com'
      'Тест'
      {
        name: if persons[0]? then ', '+persons[0].first_name else ''
        login: accounts[0].login
      }
    ).done()
  else
    console.log 'mail: Signed up with phone number, can\'t send mail'