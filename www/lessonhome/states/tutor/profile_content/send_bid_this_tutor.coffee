class @main
  tree : => module '$'  :
    button : module '../button' :
      text      : 'Отправить заявку<br>только этому<br>репетитору'
      selector  : 'send_bid_this_tutor'
      close     : true
    small_button  :  module '../button' :
      selector  : 'small_send_bid_this_tutor'
      close     : true
    have_small_button : @exports()