class @main
  tree : => @module 'lp/personal_cabinet/bid':
    value :
      active : @exports()
      bid : @exports()
      pupil : @exports()
    chat: @state './chat' :
      chat : @exports()
      pupil : @exports()
      moderator : @exports()

