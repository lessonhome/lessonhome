
month = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь']

status =
  schoolboy : 'школьник'
  student   : 'студент'
  graduate  : 'аспирант/выпускник'
  phd       : 'кандидат наук'
  phd2      : 'доктор наук'

class @F2V
  $birthday     : (data)-> data?.birthday?.getDate?()
  $birthmonth   : (data)-> month[data?.birthday?.getMonth?()]
  $birthyear    : (data)-> data?.birthday?.getFullYear?()
  $status       : (data)-> status[data?.status]
  $firstphone   : (data)-> data?.phone?[0]
  $activeTutor  : (data)-> 'active' if data?.first_name
  $registered   : (data)->
    if data?.first_name
      true
    else
      false

