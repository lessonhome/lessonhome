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
  getBalance: =>
    @$send(
      'billActions'
      {}
    ).then (res) =>
      console.log res.status
      if res.status == 'success'
        @updateBalance(res.balance)
    .done()

  refillBill: =>
    @$send(
      'billActions'
      {
        action: 'refill'
        value: +@refill.input[0].value
      }
    ).then (res) =>
      console.log res.status
      if res.status == 'success'
        @updateBalance(res.balance)
    .done()
  pay: (link) =>
    value = +link.previousSibling.innerHTML
    console.log value
    @$send(
      'billActions'
      {
        action: 'pay'
        value: value
      }
    ).then (res) =>
      console.log res.status
      if res.status == 'success'
        @updateBalance(res.balance)
      else
        popup = link.lastChild
        popup.style.display = 'block'
        setTimeout(
          ()->
            popup.style.display = 'none'
          1000
        )
    .done()
