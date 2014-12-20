class @main
  tree : -> module '$' :
    depend        : [
      module '$/edit'
      state 'lib'
    ]
    header        : state '$/header'  :
      icons       : module '$/header/icons'
      items       : @exports()
    left_menu     : state './left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    vars :
      input_width1 : '335px'
      input_width2 : '90px'
      input_width3 : '100px'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items
