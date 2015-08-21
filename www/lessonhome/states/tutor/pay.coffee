class @main extends @template '../tutor'
  route : '/tutor/pay'
  model   : 'tutor/pay'
  title : "оплата"
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
      }
      @module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
      @module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
        tag   : 'tutor:in_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
    ]
    #line_menu     : false
    #sub_top_menu  : false
    content       : @module '$' :
      balance  : 2000
      refill_many : @module 'tutor/forms/input' :
        selector  : 'fast_bid'
        #pattern   : '^[_a-zA-Z0-9а-яА-ЯёЁ ]{1,15}$'
        #errMessage: 'Введите корректное имя (имя может содержать только цифры, символы алфавита и _)'
        #value     : $form : person : 'first_name'

  init : ->
    @parent.tree.left_menu.setActive 'Оплата'
