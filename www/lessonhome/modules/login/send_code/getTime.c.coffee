@handler = ($, data) ->
  try
    accountDb =  yield $.db.get 'accounts'
    account = yield _invoke accountDb.find({id : $.user.id}, {'smsToken.next': 1}), 'toArray'
    account = account[0]
    throw {} unless account?
    throw {err: 'not_exsit'} unless account.smsToken?.next?
  catch errs
    errs['status'] = 'failed'
    errs['err'] = "internal_error" unless errs['err']?
    return errs
  return {status: 'success', time: account.smsToken.next - Date.now()}