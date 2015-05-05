class @main extends template '../preview'
  route : '/fourth_step'
  model : 'main/fourth_step'
  title : "выберите диапазон цены"
  tags  : -> 'pupil:main_search'
  access : ['pupil','other']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : state '../filter_top' :
      title : 'Выберите диапазон цены :'
      price_slider_top   : state '../slider_main' :
        selector      : 'price_slider_top'
        start         : 'price_slider_top'
        start_text    : 'от'
        end         : module 'tutor/forms/input' :
          selector  : 'price_slider_top'
          text2     : 'до'
          align : 'center'
        measurement   : 'руб.'
        min : 400
        max : 5000
        handle        : true
      link_back       :  '/third_step'







