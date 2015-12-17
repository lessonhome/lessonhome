check = require('../modules/register/content/check')

sms_time_life = 24*60 #minutes - the time limit for entering the code.
sms_period_life = 5 #minutes - frequency with witch possible send message.
sms_number_life = 10 #- Maximum the number of attempts. The number of attempts is reset to zero later time "sms_period_refresh".
sms_period_refresh = 24 #hours - The number of attempts is reset to zero after this time


@handler = ($, data = {})->
  try
    db = yield Main.service 'db'
    accountsDb = yield db.get 'accounts'
    account = yield _invoke accountsDb.find({id: $.user.id}, {changePasswordForId: 1, smsToken: 1, authToken: 1}), 'toArray'
    account = account[0]
    throw {err: 'internal_error'} unless account?

    desired_account = null

    if data.login?
      desired_account = yield _invoke accountsDb.find({login: data.login}, {id: 1}), 'toArray'
      data.id = desired_account[0]?.id ? null
    else
      throw {err: 'login_not_exists'} unless account.changePasswordForId?
      desired_account = yield _invoke accountsDb.find({id: account.changePasswordForId}, {login: 1}), 'toArray'
      data.id = account.changePasswordForId
      data.login = desired_account[0]?.login ? null

    throw {err: 'login_not_exists'} unless data.login? and data.id?

    phone = check.checkPhone(data.login)
    is_email = check.checkEmail(data.login)

    throw {err:'login_not_exists'} unless phone or is_email

    data.phone = []
    data.email = []

    data.phone.push(phone) if phone
    data.email.push(data.login) if is_email
    
    way = null
    now = new Date()

    if phone
      smsToken = null
      unless account.smsToken?.reborn?
        smsToken = {
          count: 0
          token : _randomHash(3)
          life : (new Date()).setMinutes(now.getMinutes() + sms_time_life)
          reborn : (new Date()).setHours(now.getHours() + sms_period_refresh)
          next : now
        }
      else
        smsToken = account.smsToken

      if smsToken.reborn < now then smsToken.count = 0

      if smsToken.life < now
        smsToken.token = _randomHash(3)
        smsToken.life = (new Date()).setMinutes(now.getMinutes() + sms_time_life)

      if smsToken.count < sms_number_life

        if smsToken.next <= now
          sms_service = yield Main.service 'sms'
          result = yield sms_service.send [{phone: phone, text: ''+smsToken.token}]

          if result.length and result[result.length - 1].status == 'ok'
            smsToken.next = (new Date()).setMinutes(now.getMinutes() + sms_period_life)
            ++smsToken.count
            yield _invoke accountsDb, 'update', {id: $.user.id}, $set:{smsToken, changePasswordForId: data.id}, {upsert:true}
            way = 'phone'
          else throw {err: 'error_sms'}

        else throw {err: 'send_later'}

      else throw {err: 'limit_attempt'}

    else if is_email
      email_service = yield Main.service 'mail'
      url_service = yield Main.service 'urldata'
      authToken = {
        token: _randomHash(10)
        valid: (new Date).setHours(now.getHours() + 24)
      }
      utoken = yield url_service.d2u 'authToken',{token:authToken.token}
      yield _invoke accountsDb,'update', {id: $.user.id}, $set:{authToken, changePasswordForId: data.id}, {upsert:true}

      personsDb = yield db.get 'persons'
      persons = yield _invoke personsDb.find({account: data.id}), 'toArray'
      persons = persons?[0] ? {}

      name = "#{persons?.last_name ? ''} #{persons?.first_name ? ''} #{persons?.middle_name ? ''}"
      name = name.replace /^\s+/,''
      name = name.replace /\s+$/,''
      name = ', '+ name if name
      for email in data.email ? []
        yield email_service.send(
          'restore_password.html'
          email
          'Восстановление пароля'
          {
            name: name
            login: email
            link: 'https://lessonhome.ru/new_password?'+utoken
          }
        )
      way = 'email'

  catch errs
    errs['status'] = 'failed'
    unless errs.err?
      console.log errs
      errs['err'] = 'internal_error'
    return errs

  yield $.form.flush '*',$.req,$.res
  return {status:'success', way}
