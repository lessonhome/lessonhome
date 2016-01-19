
class PayMaster
  address = "https://paymaster.ru/Payment/Init"
  type_signature = "sha1"
  ID = "263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
  secret_key = "F1267224EAFB40B4A0078BF36B42D911"
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
#    yield @jobs.listen 'withdraw',@withdraw
#    yield @jobs.listen 'refill',@refill
    yield @jobs.listen 'makeCheck',@makeCheck
    yield @jobs.listen 'waitPay', @getPay
    yield @jobs.listen 'addTrans', @addTrans
#    yield @jobs.listen 'delTrans', @delTrans
    @bills = yield @db.get 'bills'

  getPay : ({url, body}) =>
    body = body[0] if body.length
    if yield @validAnswer body
      yield @_confirmTrans(body['LMI_PAYMENT_NO'], body['LMI_SYS_PAYMENT_ID'])

    return {status: 301, body: ''}

  makeCheck : ({user, amount})=>
    @_validUser(user)
    amount = parseFloat(amount)
    throw new Error('wrong_amount') if isNaN(amount)
    amount =  Math.floor(amount*10)/10
    description = "Пополнение счета LessonHome"
    {number} = yield @_newTransaction(user, 'fill', amount, description)
    return {status: "success", url: yield @_getUrl(amount, number, description)}

  refill : ({user, amount, desc}) => yield @_createConfirmedTrans(user, amount, 'fill', desc)
  withdraw : ({user, amount, desc}) => yield @_createConfirmedTrans(user, amount, 'pay', desc)

  delTrans : ({user, number}) =>
    @_validUser(user, true)
    bill = yield _invoke @bills.find({account : user.id}, {transactions : 1, residue: 1}), 'toArray'
    bill = bill[0] || {}
    throw new Error('Not exist transaction') unless bill.transactions?[number]?
    curr_res = bill.residue || 0
    residue = bill.transactions[number].value || 0
    bill.residue = (curr_res -= residue)
    delete bill.transactions[number]
    yield _invoke @bills, 'update', {account : user.id}, $set: bill, {upsert: true}
    return {status: 'success', residue: curr_res}

  _createConfirmedTrans : (user, amount, type, desc) =>
    throw new Error('Permission denied') unless user.admin
    throw new Error('Not exist user.id. Please, transfer correct user ') unless user.id?
    amount = parseFloat(amount)
    throw new Error('amount_not_num') if isNaN(amount)
    amount =  Math.floor(amount*10)/10
    {number, bill} = yield @_newTransaction(user, type, amount, desc, true)
    bill.number = number
    return {status: 'success', bill}

  _getUrl : (amount, number, description) ->
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

  _validUser: (user, admin=false)  ->
    throw new Error('Permission denied') if admin and !user.admin
    throw new Error('Not exist user.id. Please, transfer correct user ') unless user.id?
    return true


  _newTransaction : (user, type, value, desc="Описание не указано", confirm) ->
    added = yield @_newTrans user, [{type, value, desc}], confirm
    console.log JSON.stringify added
    for number, bill of added when added.hasOwnProperty(number) then break
    return {number, bill}


  _newTrans: (user, arrConf, confirm=false) =>
    bill = yield _invoke @bills.find({account : user.id}, {transactions : 1, residue: 1}), 'toArray'
    bill = bill[0] || {}
    trans = bill.transactions || {}
    residue = bill.residue || 0
    added = {}
    bills = []

    for conf in arrConf
      bills.push yield @_getBill conf

    numbers = yield @_getNumbers bills.length
    for b, i in bills

      if numbers[i]?

        if confirm
          b['status'] = 'success'
          residue = yield @_operation residue, b.value, b.type
        else
          b['status'] = 'wait'

        trans[numbers[i]] = added[numbers[i]] = b

    yield _invoke @bills, 'update', {account : user.id}, $set: {residue, transactions: trans}, {upsert: true}
    if confirm then yield @jobs.solve 'flushForm', user.id
    return added

  _getBill : (conf) ->
    date = if conf.date? then new Date(conf.date) else new Date
    throw new Error("Invalid date") if isNaN(date)
    return {
    date: date
    value: conf.value
    type: conf.type
    desc: conf.desc
    }

  _getNumbers : (count) ->
    count_char = 5
    result = []
    num = yield _invoke @bills.find({next_number_bill: {$exists: true}}, {next_number_bill: 1}), 'toArray'
    num = num[0]?.next_number_bill || 0
    count += num
    for n in [num...count]
      n = new String(n)

      if n.length > count_char
        result.push n
      else
        result.push (new Array(count_char - n.length + 1)).join('0') + n

    yield _invoke @bills, 'update',  {next_number_bill: {$exists: true}}, {next_number_bill: n}, {upsert: true}
    return result


  _confirmTrans : (num_trans, payment_id) ->
    bill = yield _invoke @bills.find({"transactions.#{num_trans}.status":'wait'}, {account: 1, residue: 1, transactions: 1}), 'toArray'
    bill = bill[0]
    return false unless bill
    residue = bill.residue || 0
    trans = bill.transactions[num_trans]

    residue = yield @_operation residue, trans.value, trans.type

    set = {
      residue
      "transactions.#{num_trans}.status" : 'success'
      "transactions.#{num_trans}.date" : new Date
    }

    if payment_id
      set["transactions.#{num_trans}.pay_id"] = payment_id

    yield _invoke @bills, 'update', {account: bill.account}, $set: set, {upsert: true}
    yield @jobs.solve 'flushForm', bill.account
    return true

  _operation : (sum ,value, type) ->
    switch type
      when 'fill'
        sum += value
      when 'pay'
        sum -= value
    return sum

module.exports = new PayMaster
