class @main
  tree : => module '$'  :
    button : module '//button_send' :
      text      : 'Отправить заявку<br>только этому<br>репетитору'
      selector  : 'send_bid_this_tutor'
    small_button  :  module '//button_send' :
      selector  : 'small_send_bid_this_tutor'
    have_small_button : @exports()