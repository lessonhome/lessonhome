class @main extends template '../registration_popup'
  route : '/tutor/profile/first_step'
  model : 'tutor/profile_registration/first_step'
  title : "первый вход"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : ->
    progress  : 1
    #data('tutor').get('registration_progress').then (p)->
    #return p if p?

    content : module '$' :
      understand_button : module 'tutor/button' :
        selector: 'understand'
        text:      'Спасибо, я понял'
      form      : state 'general_data'
  init : ->
    @parent.tree.popup.button_back.selector = 'fast_bid_nav inactive'
    @parent.tree.popup.button_back.href = false
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href = 'second_step'