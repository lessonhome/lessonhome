class @main
  tree : => @module 'lp/personal_cabinet/bid':
    active_class: 'active'
    bid_info: @state './bid_info' :
      bid : @exports()
      pupil : @exports()
    chat: @state './chat' :
      chat : @exports()
      pupil : @exports()
      moderator : @exports()

