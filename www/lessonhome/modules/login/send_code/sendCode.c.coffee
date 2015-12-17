
@handler = ($,data) ->

  try
    throw {err: 'empty_code'} unless data.code? and data.code
    accountDb =  yield $.db.get 'accounts'
    account = yield _invoke accountDb.find({id : $.user.id}), 'toArray'
    throw {err: 'not_exist'} unless account[0]?.smsToken?
    throw {err: 'timeout'} if account[0]?.smsToken.life < Date.now()
    throw {err: 'wrong_code'} unless data.code == account[0].smsToken.token
    time = new Date
    authToken = {
      token: _randomHash(10)
      valid: time.setHours(time.getHours() + 24)
    }
    yield _invoke accountDb, 'update', {id : $.user.id}, $set : {authToken}
    url_service = yield Main.service 'urldata'
    utoken = yield url_service.d2u 'authToken',{token:authToken.token}
    yield $.form.flush '*',$.req,$.res
    return {status: 'success', token: utoken}
  catch errs
    errs['status'] = 'failed'
    unless errs.err?
      console.log errs
      errs['err'] = 'internal_error'
    return errs


