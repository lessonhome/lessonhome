class @main extends @template '../tutor'
  route : '/tutor/paymaster'
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
    content       : @module '$'