
class @main
  tree : -> module '$' :
    selector      : @exports()
    sex_woman     : module 'gender_button' :
      selector  : @exports 'selector_button'
      text      : 'Ж'
    sex_man       : module 'gender_button' :
      selector  : @exports 'selector_button'
      text      : 'М'
    title         : @exports()