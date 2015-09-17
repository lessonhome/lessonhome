class @main
  tree : => @module './hide_block' :
    trigger : @module './checkbox' :
      text      : @exports 'title'
      selector  : 'small font_16'
    content : @exports()
    selector : @exports()