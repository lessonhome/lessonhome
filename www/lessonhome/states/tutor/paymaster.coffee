class @main extends @template '../tutor'
  route : '/tutor/paymaster'
  model   : 'tutor/pay'
  title : "оплата"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{bills: ['transactions', 'current_sum']}]
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
    content       : @module '$' :
      current_sum : $form: bills : 'current_sum'
      transactions : $form: bills : 'transactions'
      send_input : @module 'tutor/forms/input' :
        placeholder : 'Введите вносимую сумму'
        selector: 'write_tutor'
        allowSymbolsPattern : "^\\d*$"
      send_btn : @module 'link_button' :
        text : 'Пополнить'
        selector: 'view'
