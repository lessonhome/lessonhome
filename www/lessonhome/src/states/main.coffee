
@route  = "/"

@struct = module 'main':
  title : 1
  head    : module 'head':
    title : 2
    m :
      head : 'm.head'
  content :
    title : 3
  state  : state 'tutor/home'
@struct.head.title = 4
@struct.state.header.part = 4
