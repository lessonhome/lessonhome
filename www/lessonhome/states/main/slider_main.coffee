class @main
  tree : => @module '$' :
    selector      : @exports()
    start         : @module 'tutor/forms/input' :
      filters   : ['digits']
      allowSymbolsPattern : "^\\d*$"
      selector  : @exports 'advanced_filter_price'
      align : 'center'
      text2     : @exports 'start_text'
    # if us end(second input) determine selector and text in parent @module
    end           : @module 'tutor/forms/input' :
      filters   : ['digits']
      allowSymbolsPattern : "^\\d*$"
      selector  : @exports 'advanced_filter_price'
      align : 'center'
      text2     : @exports 'start_text'
    default       : @exports()
    value         :
      left : @exports()
      right : @exports()
      min : @exports()
      max : @exports()
      type: @exports()
    dash          : @exports()
    type          : @exports()
    measurement   : @exports()
    division_value: @exports()
    move          : @module '../slider':
      type    : @exports()
    # variable handle response left hand
