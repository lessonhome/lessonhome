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
        "(\\d\\d\\d\\d)(.+)":"$1"
      ]
      selector  : 'fast_bid'
      value : @exports()



