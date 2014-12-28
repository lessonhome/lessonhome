class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "отправьте заявку"
  tree : =>
    filter_top  : state '../filter_top'