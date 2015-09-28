class @main
  tree : => @module './full_price/hour_price' :
    currency : @exports()
    hour      : @module 'tutor/forms/checkbox' :
      text      : @exports()
      selector  : 'small font_16'
      value : @exports()

      #$form : tutor : 'isPlace.tutor'
    cost  :  @module 'tutor/forms/input'  :
      replace : [
        "[^\\d]"
      ]
      selector  : 'fast_bid'
      value : @exports()



