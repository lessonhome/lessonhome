

class @main
  access : ['tutor','pupil','other']
  redirect : {}
  route :  '/urls'
  tree : => @module 'dev/urls' :
    depend : [
      @state 'libnm'
      @module 'lib/mousewheel'
    ]

  init : =>
    arr = []
    o = {}
    for name, state of $site.state
      continue if name.match /^(dev|test)\//
      c = state.class
      if c::route?
        arr.push {
          model : c::model
          route : c::route
          name  : name
          title : c::title
        }
    for i in [0...arr.length-1]
      for j in [i+1...arr.length]
        if arr[i].model > arr[j].model
          k       = arr[i]
          arr[i]  = arr[j]
          arr[j]  = k

    @tree.states = arr
