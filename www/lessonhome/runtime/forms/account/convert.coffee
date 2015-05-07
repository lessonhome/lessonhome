

class @F2V
  $activeTutor  : (data)-> 'active' if data?.type?.tutor
  $registered   : (data)->
    console.log 'r',data
    if data?.type?.tutor || data?.type?.pupil
      true
    else
      false

