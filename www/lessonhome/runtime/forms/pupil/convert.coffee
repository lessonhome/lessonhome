


class @F2V
  $phone_call_phones_first       : (data)-> data?.phone_call?.phones?[0]
  $subjects_0_subject            : (data)-> data?.subjects?[0]?.subject
  $phone_call_description        : (data)-> data?.phone_call?.description
  #$subject                       : (data)-> data?.subjects?[0]
  $subjects_0_comments           : (data)-> data?.subjects?[0]?.comments
  $subjects_0_course             : (data)-> data?.subjects?[0]?.course
  $subjects_0_knowledge_level    : (data)-> data?.subjects?[0]?.knowledge
  $subjects_0_lesson_price_left  : (data)-> data?.subjects?[0]?.lesson_price?[0]
  $subjects_0_lesson_price_right : (data)-> data?.subjects?[0]?.lesson_price?[1]
  $subjects_0_goal               : (data)-> data?.subjects?[0]?.goal
  $first_subject                 : (data)-> data?.subjects?[0]

  $isPlace    : (data)->
    ret = {}
    tags = (yield @$first_subject(data))?.place || []
    for key,tag of tags
      ret[tag] = true
    return ret

  $isStatus    : (data)->
    ret = {}
    tags = (yield @$first_subject(data))?.requirements_for_tutor?.status || []
    for key,tag of tags
      ret[tag] = true
    return ret

  $newBid : (data)->
    last = data?.bids?[data?.bids?.length-1]
    last ?= {}
    last = {} unless last.complited == false
    return last

