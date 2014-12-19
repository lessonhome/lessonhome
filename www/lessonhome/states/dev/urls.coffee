
class @main
  route :  '/urls'
  tree : => module 'dev/urls' :
    depend : state 'lib'
  init : =>
    o = {}
    for name, state of $site.state
      c = state.class
      if c::route?
        o[name] = {
          model : c::model
          route : c::route
          name  : name
          title : c::title
        }
    @tree.states = o
        
