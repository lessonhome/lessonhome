

status =
  schoolboy : 'школьник'
  student   : 'студент'
  graduate  : 'аспирант/выпускник'
  phd       : 'кандидат наук'
  phd2      : 'доктор наук'

class @F2V
  $status       : (data)-> status[data?.status]
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