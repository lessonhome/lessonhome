@struct = module 'tutor/template' :
  header : state 'tutor/template/header'
  edit_line     : state 'tutor/template/edit_line'
  left_menu     : state 'tutor/template/left_menu'
  sub_top_menu  : undefined   # define if exists
  content       : undefined   # must be defined
### use @struct.sub_top_menu.active_item if exists sub_top_menu###