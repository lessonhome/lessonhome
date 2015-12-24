
class PayMaster
  address = "https://paymaster.ru/Payment/Init"
  type_signature = "sha1"
  id = "263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
  secret_key = "2C8AE0E31F83473E85E1AB4141D3198"
  hash = [
    "LMI_MERCHANT_ID",
    "LMI_PAYMENT_NO",
    "LMI_SYS_PAYMENT_ID",
    "LMI_SYS_PAYMENT_DATE",
    "LMI_PAYMENT_AMOUNT",
    "LMI_CURRENCY",
    "LMI_PAID_AMOUNT",
    "LMI_PAID_CURRENCY",
    "LMI_PAYMENT_SYSTEM",
    "LMI_SIM_MODE"
  ]
  constructor : ->
    $W @
  init : =>
    @db = yield Main.service 'db'
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'makeCheck',@makeCheck
    yield @jobs.listen 'waitPay', @getPay
    @bills = yield @db.get 'bills'


  getPay : ({url, body}) =>
#    is_valid = yield @validAnswer body.post
#    if is_valid
    number_check = "3840e9b1f90fede051c5"
    bill = yield _invoke @bills.find({"transactions.#{number_check}.status":'wait'}, {account: 1, transactions: 1, residue: 1}), 'toArray'
    bill = bill[0]
    residue = bill.residue || 0
    tran = bill.transactions
    residue += tran[number_check].value
    tran[number_check]['residue'] = residue
    tran[number_check].status = 'success'
    tran[number_check].date = new Date()
    yield _invoke @bills, 'update', {account: bill.account}, $set: {residue, transactions: tran}, {upsert: true}
    yield @jobs.solve 'flushForm', bill.account


    return {status: 301, body: ''}

  makeCheck : ({id_acc, amount, description})=>
    try
      throw new Error('Please, transfer account ID in "id_acc"') unless id_acc?
      bill = yield _invoke @bills.find({account: id_acc}, {transactions: 1}), 'toArray'
      is_exist = bill[0]?.transactions?
      result_trans = if is_exist then bill[0].transactions else {}
#      delete result_trans[key] for key, val of result_trans when val.status is 'wait'

      number_check = _randomHash(10)

      while is_exist and result_trans[number_check]?
        number_check = _randomHash(10)

      amount = (Math.floor(amount*10)/10)

      result_trans[number_check] = {type: 'fill', status: 'wait', date: new Date, value: amount}

      yield _invoke @bills, 'update', {account : id_acc}, {$set:{transactions: result_trans}}, {upsert: true}

      return {status: "success",url: yield @_getUrl(amount, number_check, description)}

    catch errs
      err = {status: 'failed'}
      if typeof(errs) == 'string'
        err['err'] =  errs
      else
        err['err'] = 'internal_error'
        console.log "ERROR: #{errs.stack}"
      return err


  _getUrl : (amount, number, description="Оплата услуги") =>

    get = [
      "LMI_MERCHANT_ID=#{id}"
      "LMI_PAYMENT_AMOUNT=#{amount.toFixed(2)}"
      "LMI_CURRENCY=RUB"
      "LMI_PAYMENT_NO=#{number}"
      "LMI_PAYMENT_DESC=#{encodeURIComponent(description)}"
      "LMI_SIM_MODE=0"
    ]

    return address + "?" + get.join("&")

  validAnswer : (ans) =>
    return false unless ans['LMI_HASH']?
    h = []
    h.push(ans[key] || '') for key in hash
    h.push secret_key
    h = h.join(';')
    h = _crypto.createHash(type_signature).update(h).digest('base64')
    return ans['LMI_HASH'] == h

module.exports = new PayMaster