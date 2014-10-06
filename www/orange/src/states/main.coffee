

@route  = "/"

@struct = module 'main':
  title : 1
  head    : module 'head':
    title : 2
  content : module 'body':
    title : 3
  footer : module 'footer'

@struct.main.head.title = 4

