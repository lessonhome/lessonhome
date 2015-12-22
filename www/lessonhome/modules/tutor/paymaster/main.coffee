class @main
  Dom   : =>

  show  : =>
    console.log @tree.transactions
    @tree.send_btn.class.on 'submit', =>
      console.log @tree.send_input.class.getValue()
  setLocalDate : =>
    @found.transations.find('.time').each (e) ->
      date = new Date(e.innerHTML)
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
