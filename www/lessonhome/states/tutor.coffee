class @main
  tree : -> module '$' :
    depend        : [
      module '$/edit'
      state 'lib'
    ]
    header        : state 'tutor/header'  :
      icons       : module '$/header/icons' :
        counter : '5'
      items       : @exports()
    left_menu     : state 'tutor/left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    footer        : module 'footer' :
      logo : module 'tutor/header/logo'
    vars :
      input_width1 : '335px'
      input_width2 : '90px'
      input_width3 : '100px'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items