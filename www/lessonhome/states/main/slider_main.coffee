class @main
  tree : => @module '$' :
    selector      : @exports()
    start         : @module 'tutor/forms/input' :
      filters   : ['digits']
      allowSymbolsPattern : "^\\d*$"
      selector  : @exports 'start'
      align : 'center'
      text2     : @exports 'start_text'
    # if us end(second input) determine selector and text in parent @module
    end           : @exports()
    value         : @exports()
    dash          : @exports()
    measurement   : @exports()
    move          : @module '../slider':
      handle    : @exports()
    # variable handle response left hand
