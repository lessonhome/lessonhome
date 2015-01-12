class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "выберите место занятия"
  tree : =>
    filter_top  : state '../filter_top' :
      title : 'Выберите место занятия :'