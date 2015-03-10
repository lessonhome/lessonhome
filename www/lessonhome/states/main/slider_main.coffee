class @main
  tree : => module '$' :
    selector      : @exports()
    start         : module 'tutor/forms/input' :
      selector  : @exports 'start'
      text      : @exports 'start_text'
    # if us end(second input) determine selector and text in parent module
    end           : @exports()
    min           : 0
    max           : 100
    dash          : @exports()
    measurement   : @exports()
    move          : module '../slider':
      handle    : @exports()
    # variable handle response left hand