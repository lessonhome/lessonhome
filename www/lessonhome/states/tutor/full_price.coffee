class @main
  tree : => @module '$' :
    place      : @module 'tutor/forms/checkbox' :
      text      : @exports()
      selector  : 'small font_16'
      #$form : tutor : 'isPlace.tutor'
    one_hour    : @state './hour_price' :
      text  : '60 мин.'
      value : @exports 'value.hour'
    two_hour    : @state './hour_price' :
      text  : '90 мин.'
    three_hour  : @state './hour_price' :
      text  : '120 мин.'
