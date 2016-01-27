

os = require 'os'
hostname = os.hostname()


@handler = ($,data)->
  #$.req.udata.onceAuth.hash
  if data?.password?.match? /\%/
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

  @delayRegisterMail($.user.id,$.user.admin).done()

  return {status:'success'}

_phones = [
  '79254688208'
  '79152292244'
  '79267952303'
  '79651818071'
]



@delayRegisterMail = (id,isadmin)->
  return if isadmin || (hostname != 'pi0h.org')
  yield Q.delay 1000*60*5

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
  text = "Регистрация репетитора\n"
  text += "#{name}\n" if name
  name = ', '+ name if name
  text += "#{accounts[0].login}\n"
  text += "#{persons[0].phone.join?('; ') ? ''}\n" if persons[0]?.phone?[0]
  text += "#{persons[0].email.join?('; ') ? ''}\n" if persons[0]?.email?[0]

  @jobs = yield Main.service 'jobs'
  messages = []
  for phone in _phones
    messages.push
      phone:phone
      text :text
  Q.spawn => yield @jobs.solve 'sendSms',messages

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
