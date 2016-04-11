class @main
  tree : => @module 'lp/personal_cabinet/bid':
    active_class: 'active'
    value :
      bid : @exports()
      pupil : @exports()
    chat: @state './chat' :
      chat : @exports()
      pupil : @exports()
      moderator : @exports()

