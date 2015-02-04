class @main
  tree : => module '$' :
    header : @exports()
    pupil_toggle : module 'link_button' :
      link : 'invite_student'
      text : 'ученик'
      selector : @exports()
    tutor_toggle : module 'link_button' :
      link : 'invite_teacher'
      text : 'репетитор'
      selector:  @exports()
    friend_name   : module 'tutor/forms/input'
    friend_email  : module 'tutor/forms/input'
    your_name     : module 'tutor/forms/input'
    invite_button : module '//invite_button'