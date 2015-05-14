

class @F2V
  $activeTutor  : (data)-> 'active' if data?.type?.tutor
  $registered   : (data)->
    if data?.type?.tutor || data?.type?.pupil
      true
    else
      false
  $registration_progress : (data)->
    s = data?.status
    return 5 if s?.tutor_prereg_4
    return 4 if s?.tutor_prereg_3
    return 3 if s?.tutor_prereg_2
    return 2 if s?.tutor_prereg_1
    return 1

  $fast_bid_progress : (data)->
    if data?.status?.fast_bid
      return data.status.fast_bid
    else
      return 1
