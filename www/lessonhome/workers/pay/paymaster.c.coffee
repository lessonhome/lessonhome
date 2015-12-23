





class PayMaster

  constructor : ->
    @addres = "https://paymaster.ru/Payment/Init"
    @type_signature = "sha1"
    @secret_key = "2C8AE0E31F83473E85E1AB4141D3198"
    @hash = [
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
    @params = {
      "LMI_MERCHANT_ID":"263bd7cb-0fa3-43c6-aa72-e209c0fc4649"
      "LMI_PAYMENT_AMOUNT": null
      "LMI_CURRENCY":"RUB"
      "LMI_PAYMENT_NO": null
      "LMI_PAYMENT_DESC":null
      "LMI_SIM_MODE":"0"
    }
    $W @
  init : =>
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'getCheck',@makeCheck
    yield @jobs.listen 'validAnsMasterPay',@isValidAnswer
    yield @jobs.solve 'pay',{amount:2000}

  makeCheck : (amount)=>
    number = @_createCheck amount
    return null unless number?
    return {url: @_getUrl(), number}

  _createCheck : (amount, description="Оплата предоставляемых услуг") =>
    return null if typeof(amount) != 'number' or isNaN(amount)
    amount = (Math.floor(amount*10)/10).toFixed(2)
    @params["LMI_PAYMENT_AMOUNT"] = amount
    @params["LMI_PAYMENT_DESC"] = description
    return @params["LMI_PAYMENT_NO"] = _randomHash(10)

  _getUrl :  =>
    get = []
    get.push("#{key}=#{value || ''}") for key, value of @params
    return @addres + "?" + get.join("&")

  isValidAnswer : (ans) =>
    return false unless ans['LMI_HASH']?
    h = []
    h.push(ans[key] || '') for key in @hash
    h.push @secret_key
    md = requ
    h = h.join(';')
    h = _crypto.createHash(@type_signature).update(h).digest('base64')
    return ans['LMI_HASH'] == h

module.exports = new PayMaster




