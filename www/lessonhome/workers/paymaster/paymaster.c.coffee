
class PayMaster
  address = "https://paymaster.ru/Payment/Init"
  type_signature = "sha1"
  ID = "263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
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
#    number = "00008"
#    yield @_confirmTrans(number)

    return {status: 301, body: ''}

  makeCheck : ({id_acc, amount, description})=>
    try
      throw new Error('Please, transfer account ID in "id_acc"') unless id_acc?
      amount = parseFloat(amount)
      throw 'amount_not_num' if isNaN(amount)
      number = yield @_newTransaction(id_acc, 'fill', amount)
      return {status: "success", url: yield @_getUrl(amount, number, description)}

    catch errs
      err = {status: 'failed'}
      if typeof(errs) == 'string'
        err['err'] =  errs
      else
        err['err'] = 'internal_error'
        console.log "ERROR: #{errs.stack}"
      return err


  _getUrl : (amount, number, description="Оплата услуги") =>
    console.log amount
    get = [
      "LMI_MERCHANT_ID=#{ID}"
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

  _getNumber : =>
    n = 5
    count = yield _invoke @bills.find({next_number_bill: {$exists: true}}, {next_number_bill: 1}), 'toArray'
    count = count[0]
    unless count
      yield _invoke @bills, 'insert', {next_number_bill: 2}
      return (new Array(n)).join('0') + '1'
    else
      yield _invoke @bills, 'update', {next_number_bill: {$exists: true}}, {$inc: {next_number_bill: 1}}
      count = count.next_number_bill
      count = new String(count)
      return count if n <= count.length
      return (new Array(n - count.length + 1)).join('0') + count

  _newTransaction : (id_acc, type, value, status = "wait", rem_old = true) =>
    trans = yield _invoke @bills.find({account : id_acc}, {transactions : 1, _id: 0}), 'toArray'
    trans = trans[0]
    trans = if trans? then trans.transactions else {}
    if rem_old then delete trans[key] for key, val of trans when val.status is 'wait'
    number = yield @_getNumber()
    trans[number] = {type, status, value : Math.floor(value*10)/10, date: new Date}
    set = {$set: transactions : trans}
    yield _invoke @bills, 'update', {account : id_acc}, set, {upsert: true}
    return number

  _confirmTrans : (num_trans) =>
    bill = yield _invoke @bills.find({"transactions.#{num_trans}.status":'wait'}, {account: 1, residue: 1, transactions: 1}), 'toArray'
    console.log bill
    bill = bill[0]
    return false unless bill
    residue = bill.residue || 0

    switch bill.transactions[num_trans].type
      when 'fill'
        residue += bill.transactions[num_trans].value

    set = {
      residue
      "transactions.#{num_trans}.residue" : residue
      "transactions.#{num_trans}.status" : 'success'
      "transactions.#{num_trans}.date" : new Date
    }

    yield _invoke @bills, 'update', {account: bill.account}, $set: set, {upsert: true}
    yield @jobs.solve 'flushForm', bill.account
    return true

  writeOff : (id_acc, amount) =>
    yield @_newTransaction(id_acc, 'pay', amount, 'success', false)


module.exports = new PayMaster