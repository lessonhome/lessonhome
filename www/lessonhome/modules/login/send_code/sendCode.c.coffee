max_count_attempt = 3
token_period_life = 24 #hours

@handler = ($,data) ->

  try
    throw 'empty_code' unless data.code? and data.code
    accountDb =  yield $.db.get 'accounts'
    account = yield _invoke accountDb.find({id : $.user.id}, {'smsToken.life': 1, 'smsToken.token': 1, 'smsToken.att_count': 1, changePasswordForId: 1}), 'toArray'
    throw 'not_exist' unless account[0]?.smsToken? and account[0].changePasswordForId?
    throw 'timeout' if account[0].smsToken.life < Date.now()
    throw 'max_attempt' if account[0].smsToken.att_count? and account[0].smsToken.att_count >= max_count_attempt

    unless _hash(data.code) == account[0].smsToken.token
      yield _invoke accountDb, 'update', {id : $.user.id},  $inc: {'smsToken.att_count': 1}
      yield $.form.flush '*',$.req,$.res
      throw 'wrong_code'
    time = new Date
    authToken = {
      token: _randomHash(10)
      valid: time.setHours(time.getHours() + token_period_life)
    }

    yield _invoke accountDb, 'update', {id : account[0].changePasswordForId}, $set : {authToken}
    url_service = yield Main.service 'urldata'
    utoken = yield url_service.d2u 'authToken',{token:authToken.token}
    yield $.form.flush '*',$.req,$.res
    return {status: 'success', token: utoken}
  catch errs
    err = {status: 'failed'}
    if typeof(errs) == 'string'
      err['err'] =  errs
    else
      err['err'] = 'internal_error'
      console.log "ERROR: #{errs.stack}"
    return err


