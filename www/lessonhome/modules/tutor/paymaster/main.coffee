class @main
  Dom   : =>
    @input = @tree.send_input.class
  show  : =>
    console.log "hello", @tree.current_sum
    @tree.send_btn.class.on 'submit', @sendPay
    @setLocalDate()

  setLocalDate : =>
    @found.transations.find('.time').each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'
  sendPay : =>
    value = @input.getValue()
    if err = @js.check value
      @showError {err}
      return
    {status, error, get} = yield @$send "./sendPay", {value}
    console.log status, error, get
    if status == 'success'
      window.open(get)
    else @showError error
  showError : (err) ->
    alert err.err