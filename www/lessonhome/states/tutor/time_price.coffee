class @main
  tree : => @module '$' :
    one_hour    : @state './hour_price' :
      text  : '60 мин.'
      value : @exports 'value.one_hour'
      currency : @exports()
    two_hour    : @state './hour_price' :
      text  : '90 мин.'
      value : @exports 'value.two_hour'
      currency : @exports()
    three_hour  : @state './hour_price' :
      text  : '120 мин.'
      value : @exports 'value.three_hour'
      currency : @exports()