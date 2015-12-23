@handler = ($, data) =>
  try
    throw 'empty' unless data?.value?
    val = parseFloat(data.value)
    val = Math.floor(val*10)/10
    throw 'wrong' if isNaN(val) or val < 300
    bills = yield $.db.get 'bills'
    yield _invoke bills, 'remove', {account: $.user.id, type: 'wait'}
    curr_sum = yield _invoke bills.find({account: $.user.id}, {_id: 0, residue: 1}).sort({date: -1}).limit(1), 'toArray'
    curr_sum = if curr_sum?[0]?.residue? then parseFloat(curr_sum[0].residue) else 0
    curr_sum = 0 if isNaN(curr_sum)
    curr_sum += val
    check_number = _randomHash(10)
    curr_sum = curr_sum.toFixed(2)
    val = val.toFixed(2)
    get = [
      "LMI_MERCHANT_ID=263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
      "LMI_PAYMENT_AMOUNT=#{val}"
      "LMI_CURRENCY=RUB"
      "LMI_PAYMENT_NO=#{check_number}"
      "LMI_PAYMENT_DESC=Оплата услуги по поиску ученика"
      "LMI_SIM_MODE=0"
    ]
    yield _invoke bills, 'insert', {type: 'wait', date: new Date, account: $.user.id, value: val, residue: curr_sum, check: check_number}
    yield $.form.flush '*',$.req,$.res
    return {status: 'success', get: get.join('&')}
  catch errs
    err = {status: 'failed'}
    if typeof(errs) == 'string'
      err['err'] =  errs
    else
      err['err'] = 'internal_error'
      console.log "ERROR: #{errs.stack}"
    return err
