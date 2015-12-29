class @main extends @template '../edit_description'
  route : '/sms'
  model   : 'tutor/edit/description/career'
  title : "отправка смс"
  tags : -> 'edit: reviews'
  access : ['admin']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
    'tutor' : '/enter'
  }
  tree : => tutor_edit : @module '$':
    phone : @module 'tutor/forms/input':
      selector : 'fast_bid'
    text : @module 'tutor/forms/textarea':
      selector : 'fast_bid'
      height : '100px'
    send_message : @module 'tutor/button' :
      text : 'отправить смс'
      selector : 'edit_save'
  init : ->
    @parent.parent.parent.tree.left_menu.setActive 'Отправить смс'
