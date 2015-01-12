class @main extends template '../preview'
  route : '/fourth_step'
  model : 'main/fourth_step'
  title : "выберите диапозон цены"
  tree : =>
    filter_top  : state '../filter_top' :
      title : 'Выберите диапозон цены :'