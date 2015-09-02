class @main extends @template '../tutor'
  route : '/tutor/support'
  model   : 'main/application/1_step'
  title : "Поддержка"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    items : [
      @module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
        #tag   : 'tutor:search_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
      @module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
    ]
    content : @module '$' :
      selector:   'tutor_profile'
      question   : @module 'tutor/forms/input'  :
        selector: 'support'
      ask_button : @module 'tutor/button' :
        text     : 'ЗАДАТЬ ВОПРОС'
        selector : 'support'


  init : ->
    @parent.tree.left_menu.setActive 'Поддержка'
