class @main
  Dom   : =>
  show  : =>
    @getBalance()
    @bids = @tree.need_pay
    @refill = @tree.refill_many.class

    @refill.on 'submit', @refillBill

    console.log @bids

    #bid.on 'click', alert(111) for bid in document.getElementsByClassName('pay_link')
    console.log bid for bid in document.getElementsByClassName('pay_link')

    console.log bid

    bid.on('click', console.log 'asfas')

  getBalance: =>
    @$send(
      'getBill'
      {
        action: 'get_balance'
      }
    ).then (res) ->
      console.log res.status
      if res.status == 'success'
        bal = document.getElementsByClassName('balance')
        bal[0].innerHTML = res.balance + ' руб.'
    .done()

  refillBill: =>
    @$send(
      'getBill'
      {
        action: 'refill'
      }
    ).then (res) ->
      console.log res.status
      if res.status == 'success'
        bal = document.getElementsByClassName('balance')
        bal[0].innerHTML = res.balance + ' руб.'
    .done()
