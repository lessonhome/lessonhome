class @main
  Dom   : =>
    @input = @tree.send_btn.class
  show  : =>
    console.log @tree.transactions
    @tree.send_btn.class.on 'submit', => @sendPay()
    @setLocalDate()

  setLocalDate : =>
    @found.transations.find('.time').each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'
  sendPay : =>
    {status, err, get} = yield @$send "./sendPay", {value : @tree.send_input.class.getValue()}
    console.log status, err, get
    if status == 'success'
      window.open("https://paymaster.ru/Payment/Init?#{get}")