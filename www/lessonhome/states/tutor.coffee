class @main
  tree : => @module '$' :
    depend        : [
      @state 'libnm'
    ]
    bottom_block_attached : @module 'main/attached' :
      bottom_bar  : @state 'main/attached/bar'
      popup       : @state 'main/attached/popup'
    header        : @state 'tutor/header'  :
      icons       : @module '$/header/icons' :
        counter : '5'
      items     : @exports()
      line_menu : @exports()
    left_menu     : @state 'tutor/left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    footer        : @state 'footer'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items
