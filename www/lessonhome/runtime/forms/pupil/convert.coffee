


class @F2V
  $phone_call_phones_first       : (data)-> data?.phone_call?.phones?[0]
  $subjects_0_subject            : (data)-> data?.subjects?[0]?.subject
  $phone_call_description        : (data)-> data?.phone_call?.description
  $subjects_0_comments           : (data)-> data?.subjects?[0]?.comments
  $subjects_0_course             : (data)-> data?.subjects?[0]?.course
  $subjects_0_knowledge_level    : (data)-> data?.subjects?[0]?.course
  $subjects_0_lesson_price_left  : (data)-> data?.subjects?[0]?.lesson_price?[0]
  $subjects_0_lesson_price_right : (data)-> data?.subjects?[0]?.lesson_price?[1]
  $subjects_0_goal               : (data)-> 
    for key, val of subjects
      return val.goal