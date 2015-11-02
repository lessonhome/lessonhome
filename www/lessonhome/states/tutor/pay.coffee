class @main extends @template '../tutor'
  route : '/tutor/pay'
  model   : 'tutor/pay'
  title : "оплата"
  access : ['tutor']
  forms : [{person:['balance']}]
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    items : [
    ]
    content       : @module '$' :
      balance  : $form : person : 'balance'
      refill_many : @module 'tutor/forms/input' :
        selector  : 'fast_bid'
      need_pay : [
      ]

  init : ->
    @parent.tree.left_menu.setActive 'Оплата'
