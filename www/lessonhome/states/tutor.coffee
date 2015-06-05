class @main
  tree : => @module '$' :
    depend        : [
      @state 'lib'
    ]
    header        : @state 'tutor/header'  :
      icons       : @module '$/header/icons' :
        counter : '5'
      items : @exports()
    left_menu     : @state 'tutor/left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    footer        : @state 'footer'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items
