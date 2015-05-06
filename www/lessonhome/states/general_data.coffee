
class @main
  forms : ['person':['avatar','first_name','last_name','middle_name','sex','birthday','birthmonth','birthyear'],'tutor':'status']
  tree : -> module '$' :
    add_photos   : module 'add_photos' :
      depend : [
        module 'lib/jquery/ui_widget'
        module 'lib/jquery/iframe_transport_plugin'
        module 'lib/jquery/fileupload'
      ]
      $form : person : avatar : 'photo'
    first_name  : module 'tutor/forms/input':
      text2 : 'Имя :'
      selector    : 'first_reg'
      hint        : 'Поле должно содержать только символы русского или английского алфавита'
      #value       : data('person').get('first_name')
      $form   : person : 'first_name'
    last_name   : module 'tutor/forms/input':
      replace : '[^a-zA-Zа-яА-ЯёЁ]'
      selector    : 'first_reg'
      text2       : 'Фамилия :'
      #value       : data('person').get('last_name')
      $form   : person : 'last_name'
    middle_name  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text2       : 'Отчество :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
      #value       : data('person').get('middle_name')
      $form   : person : 'middle_name'
    gender_data   : state 'gender_data':
      selector        : 'choose_gender'
      title           : 'true'
      selector_button : 'registration'
      value           : $form : person : 'sex'
      #data('person').get('sex').then (s)->
      #return s if s?
      #return false
      #$form   : 'tutor' : 'sex'
    birth_data    : state 'data_date'  :
      text  : 'Дата рождения :'
      #day_value   : data('person').get('birthday').then (b)-> b?.getDate?()
      #month_value : data('person').get('birthday').then (b)-> data('convert').convertNumberToMonth(b?.getMonth?())
      #year_value  : data('person').get('birthday').then (b)-> b?.getFullYear?()
      day_value   : $form : person : 'birthday'
      month_value : $form : person : 'birthmonth'
      year_value  : $form : person : 'birthyear'
    status      : module 'tutor/forms/drop_down_list' :
      text        : 'Статус :'
      selector    : 'first_reg'
      scroll      : module 'tutor/forms/drop_down_list/scroll' :
        paramsData  : {} #{findContainerMethod:'prev'}
      options_count: 7
      #value: data('tutor').get('status').then (s)->
      #  if s then data('convert').convertStatusToRus s
      $form : tutor : 'status'
      default_options     : {
        '0': {value: 'schoolboy', text: 'школьник'},
        '1': {value: 'student', text: 'студент'},
        '2': {value: 'graduate', text: 'аспирант/выпускник'},
        '3': {value: 'phd', text: 'кандидат наук'},
        '4': {value: 'phd2', text: 'доктор наук'}
      }



