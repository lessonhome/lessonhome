class @main extends @template '../tutor'
  route : '/tutor/paymaster'
  model   : 'tutor/pay'
  title : "оплата"
  access : ['other','pupil','admin','tutor']
  forms : [{person:['balance']}]
  redirect : {
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
