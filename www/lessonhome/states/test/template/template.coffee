

class @main
  tree : -> module 'tutor/template' :
    depend        : [
      module 'lib/jquery'
    ]
    header        : state './header'
    #edit_line     : state './edit_line'
    left_menu     : state './left_menu'
    sub_top_menu  : @exports()
    content       : @exports()
    vars :
      input_width1 : '335px'
      input_width2 : '84px'
      input_width3 : '100px'
# use @struct.sub_top_menu.active_item if exists sub_top_menu

