

status =
  schoolboy : 'школьник'
  student   : 'студент'
  graduate  : 'аспирант/выпускник'
  phd       : 'кандидат наук'
  phd2      : 'доктор наук'


class @MB2F
  $tutor : =>
    return

class @MF2V
  $tutor : (data)=>
    data
  ###
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
      left : r?[0] | 500
      right : r?.pop?() | 1500
    }
    return ret
  ###
