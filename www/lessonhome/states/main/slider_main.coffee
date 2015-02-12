class @main
  tree : => module '$' :
    selector  : @exports()
    start     : module 'tutor/forms/input' :
      selector    : @exports 'start'
    end       : module 'tutor/forms/input' :
      selector  : @exports 'end'
    dash        : @exports()
    measurement : @exports()
    move     : module '../slider'
    selector_two  : @exports()