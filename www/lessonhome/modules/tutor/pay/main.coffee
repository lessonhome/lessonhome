class @main
  Dom   : =>
  show  : =>
    @getBalance()
    @bids = @tree.need_pay
    @refill = @tree.refill_many.class

    @refill.on 'submit', @refillBill

    @refill_button = document.getElementsByClassName('button_balance')[0]
    @refill_button.onclick = () =>
      @refillBill()

    for link in document.getElementsByClassName('pay_link')
      do (link) =>
        link.onclick = () =>
          @pay(link)

  updateBalance: (value) =>
    bal = document.getElementsByClassName('balance')
    bal[0].innerHTML = value + ' руб.'
  getBalance: => Q.spawn =>
    res = yield @$send(
      'billActions'
      {}
    )
    if res.status == 'success'
      @updateBalance(res.balance)
  refillBill: => Q.spawn =>
    res = yield @$send(
      'billActions'
      {
        action: 'refill'
        value: +@refill.input[0].value
      }
    )
    if res.status == 'success'
      @updateBalance(res.balance)
  pay: (link) => Q.spawn =>
    value = +link.previousSibling.innerHTML
    res = yield @$send(
      'billActions'
      {
        action: 'pay'
        value: value
      }
    )
    if res.status == 'success'
      @updateBalance(res.balance)
    else
      popup = link.lastChild
      popup.style.display = 'block'
      setTimeout ->
        popup.style.display = 'none'
      , 1000
