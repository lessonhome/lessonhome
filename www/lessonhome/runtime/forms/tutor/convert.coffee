

status =
  schoolboy : 'школьник'
  student   : 'студент'
  graduate  : 'аспирант/выпускник'
  phd       : 'кандидат наук'
  phd2      : 'доктор наук'

class @F2V
  $status       : (data)-> status[data?.status]
  $settings_new_orders : (data)-> data?.settings?.new_orders

