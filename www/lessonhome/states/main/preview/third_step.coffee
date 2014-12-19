class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "отправьте заявку"
  tree : =>
    top_filter : module '$/top_filter'