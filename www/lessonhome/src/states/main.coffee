
@route  = "/"

@struct = module 'main':
  title : 1
  head    : module 'head':
    title : 2
  content : module 'body':
    title : 3
  footer : module 'footer'
  state  : state 'tutor/home'
@struct.head.title = 4
@struct.state.header.part = 4
