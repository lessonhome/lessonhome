

class @F2V
  $activeTutor  : (data)-> 'active' if data?.type?.tutor
  $registered   : (data)->
    if data?.type?.tutor || data?.type?.pupil
      true
    else
      false

