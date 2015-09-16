class @main
  tree : => @module './full_price/hour_price' :
    hour      : @module 'tutor/forms/checkbox' :
      text      : @exports()
      selector  : 'small font_16'
      value : @exports()
      #$form : tutor : 'isPlace.tutor'
    cost  :  @module 'tutor/forms/input'  :
      selector  : 'fast_bid'
      value : @exports()


