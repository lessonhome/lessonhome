class @main extends @template '../tutor'
  route : '/tutor/pay'
  model   : 'tutor/pay'
  title : "оплата"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{bills: ['transactions', 'current_sum', 'toPay']}]
  tree : =>
    items : []
    content       : @module '$' :
      current_sum : $form: bills : 'current_sum'
      transactions : $form: bills : 'transactions'
      send_input : @module 'tutor/forms/input' :
        placeholder : 'Введите вносимую сумму'
        value: $form: bills : 'toPay'
        selector: 'write_tutor'
        allowSymbolsPattern : "^\\d*$"
      send_btn : @module 'link_button' :
        text : 'Пополнить'
        selector: 'view'
  init : ->
    @parent.tree.left_menu.setActive 'Оплата'
