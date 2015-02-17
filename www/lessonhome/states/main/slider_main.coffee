class @main
  tree : => module '$' :
    selector      : @exports()
    start         : module 'tutor/forms/input_label' :
      selector  : @exports 'start'
      text      : @exports 'start_text'
    end           : module 'tutor/forms/input_label' :
      selector  : @exports 'end'
      text      : @exports 'end_text'
    dash          : @exports()
    measurement   : @exports()
    move          : module '../slider'
    selector_two  : @exports()