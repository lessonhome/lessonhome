@handler = ($, data) ->
  try
    accountDb =  yield $.db.get 'accounts'
    account = yield _invoke accountDb.find({id : $.user.id}, {'smsToken.next': 1}), 'toArray'
    account = account[0]
    throw 'not_account' unless account?
    throw 'not_send' unless account.smsToken?.next?
    return {status: 'success', time: account.smsToken.next - Date.now()}
  catch errs
    err = {status: 'failed'}
    if typeof(errs) == 'string'
      err['err'] =  errs
    else
      err['err'] = 'internal_error'
      console.log "ERROR: #{errs.message}"
    return err
