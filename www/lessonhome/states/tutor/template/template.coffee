@struct = module 'tutor/template' :
  header : state './header'
  edit_line     : state './edit_line'
  left_menu     : state './left_menu'
  sub_top_menu  : undefined   # define if exists
  content       : undefined   # must be defined
### use @struct.sub_top_menu.active_item if exists sub_top_menu###
