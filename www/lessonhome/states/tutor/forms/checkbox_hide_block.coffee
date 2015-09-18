class @main
  tree : => @module './hide_block' :
    trigger : @module './checkbox' :
      value : @exports 'is_show'
      text      : @exports 'title'
      selector  : 'small font_16'
    content : @exports()
    selector : @exports()
    is_show : @exports()