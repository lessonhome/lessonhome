

class @main
  access : ['tutor','pupil','other']
  redirect : {}
  forms : [{'person':['first_name']}]
  route :  '/urls'
  tree : => module 'dev/urls' :
    map : module 'maps/yandex':
      value : "береговой проезд 2 3"
    depend : [
      state 'lib'
      module 'lib/mousewheel'
    ]
    user : $form :person:"first_name"

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
