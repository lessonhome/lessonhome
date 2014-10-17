
@route = "/page1"

@struct = state 'test/home_template'

@struct.content = module 'page1' :
  title : ""

@struct.top.title = "page1"