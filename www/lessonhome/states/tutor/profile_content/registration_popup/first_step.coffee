class @main extends @template '../registration_popup'
  forms : [{account:['registration_progress']}]
  route : '/tutor/profile/first_step'
  model : 'tutor/profile_registration/first_step'
  title : "первый вход"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    progress  : $form : account : 'registration_progress'
    current_progress: 1
    selector_button_back  : 'fast_bid_nav inactive'
    href_button_back      : ''
    href_button_next      : 'second_step'
    close   : false
    content : @module '$' :
      understand_button : @module 'tutor/button' :
        selector: 'understand'
        text:      'Спасибо, я понял'
      form      : @state 'general_data'