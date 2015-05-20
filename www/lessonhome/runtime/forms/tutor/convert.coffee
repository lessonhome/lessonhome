

status =
  schoolboy : 'школьник'
  student   : 'студент'
  graduate  : 'аспирант/выпускник'
  phd       : 'кандидат наук'
  phd2      : 'доктор наук'

class @F2V
  $status       : (data)-> status[data?.status]
  $status2       : (data)-> status[data?.status]
  $settings_new_orders : (data)-> data?.settings?.new_orders
  $settings_get_notifications_sms : (data)->
    if data?.settings?.get_notifications?
      for key, val of data.settings.get_notifications
        if val == 'sms' then return true
      return false
    else
      return true
  $settings_get_notifications_email : (data)->
    if data?.settings?.get_notifications?
      for key, val of data.settings.get_notifications
        if val == 'email' then return true
      return false
    else
      return true
  $settings_call_operator_possibility : (data)-> data?.settings?.call_operator_possibility
  $phone_call_description : (data)-> data?.phone_call?.description
  $calendar : (data)-> data?.calendar || {}
  $subject  : (data)-> data?.subjects?[0]
  $isTag    : (data)->
    ret = {}
    tags = (yield @$subject(data))?.tags || []
    for key,tag of tags
      ret[tag] = true
    return ret
  $isPlace    : (data)->
    ret = {}
    tags = (yield @$subject(data))?.place || []
    for key,tag of tags
      ret[tag] = true
    return ret
  $srange   : (data)->
    r = (yield @$subject(data))?.price?.range
    ret =  {
      left : r?[0] || 500
      right : r?.pop?() || 1500
    }
    return ret
  $sduration  : (data)->
    d = (yield @$subject(data))?.price?.duration
    if d?
      ret = d + " минут"
    else
      ret = ''
    return ret
  $splace : (data)->
    places = {'tutor':'у репетитора', 'pupil':'у ученика', 'remote':'удалённо', other:'другое место'}
    ret = ''
    p = (yield @$subject(data))?.place
    if p?
      for key,val of p
        ret += places[val]+", "
      if ret.length
        ret = ret.substring(0, ret.length - 2)
    return ret

  $scategory_of_student : (data)->
    #categories_of_student = {'school:0':'дошкольники', 'school:1':'младшая школа', 'school:2':'средняя школа', 'school:3':'старшая школа', 'student':'студент', 'adult':'взрослый'}
    ret = ''
    tags = (yield @$subject(data))?.tags
    if tags? && tags
      for key,tag of tags
        switch tag
          when "school:0"
            ret += "дошкольники, "
          when "school:1"
            ret += "младшая школа, "
          when "school:2"
            ret += "средняя школа, "
          when 'school:3'
            ret += "старшая школа, "
          when 'student'
            ret += "студент, "
          when 'adult'
            ret += "взрослый, "

      if ret.length
        ret = ret.substring(0, ret.length - 2)

    return ret



