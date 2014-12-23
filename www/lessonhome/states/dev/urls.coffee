
class @main
  route :  '/urls'
  tree : => module 'dev/urls' :
    depend : [
      state 'lib'
      module 'lib/mousewheel'
    ]
  init : =>
    o = {}
    for name, state of $site.state
      continue if name.match /^(dev|test)\//
      c = state.class
      if c::route?
        o[name] = {
          model : c::model
          route : c::route
          name  : name
          title : c::title
        }
    @tree.states = o
        
