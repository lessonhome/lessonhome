
class @main
  tree : -> module 'tutor/template' :
    header        : state './header'
    left_menu     : state './left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    vars :
      input_width1 : '335px'
      input_width2 : '90px'
      input_width3 : '100px'