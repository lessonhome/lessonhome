class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  dir   : 'main/third_step'
  tree : =>
    top_filter : module '$/top_filter'