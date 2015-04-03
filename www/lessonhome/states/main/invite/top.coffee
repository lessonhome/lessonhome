class @main
  tree : => module '$' :
    header : @exports()
    pupil_toggle : module 'link_button' :
      href : 'invite_student'
      text : 'ученик'
      selector : @exports()
    tutor_toggle : module 'link_button' :
      href : 'invite_teacher'
      text : 'репетитор'
      selector:  @exports()
    friend_name   : module 'tutor/forms/input':
      text1     : 'Имя друга :'
      selector  : 'fast_bid'
    friend_email  : module 'tutor/forms/input':
      text1     : 'E-mail друга :'
      selector  : 'fast_bid'
    your_name     : module 'tutor/forms/input':
      text1     : 'Ваше имя :'
      selector  : 'fast_bid'
    invite_button : module 'tutor/button' :
      text: 'Пригласить!'
      selector: 'invite'
