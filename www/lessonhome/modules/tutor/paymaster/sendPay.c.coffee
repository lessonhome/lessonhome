@check = require('./check')
@addres_pay = "https://paymaster.ru/Payment/Init"
@handler = ($, data) =>
  try
    if err = @check.check(data.value) then throw err
    val = parseFloat(data.value)
    val = Math.floor(val*10)/10
    bills = yield $.db.get 'bills'
    yield _invoke bills, 'remove', {account: $.user.id, status: 'wait'}

    check_number = _randomHash(10)
    get = [
      "LMI_MERCHANT_ID=263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
      "LMI_PAYMENT_AMOUNT=#{val}"
      "LMI_CURRENCY=RUB"
      "LMI_PAYMENT_NO=#{check_number}"
      "LMI_PAYMENT_DESC=Оплата услуги по поиску ученика"
      "LMI_SIM_MODE=0"
    ]

    val = val.toFixed(2)
    yield _invoke bills, 'insert', {type: 'fill', status: 'wait', date: new Date, account: $.user.id, value: val, check: check_number}
    yield $.form.flush '*',$.req,$.res
    return {status: 'success', get: @addres_pay + '?' + get.join('&')}
  catch errs
    err = {status: 'failed'}
    if typeof(errs) == 'string'
      err['err'] =  errs
    else
      err['err'] = 'internal_error'
      console.log "ERROR: #{errs.stack}"
    return err
