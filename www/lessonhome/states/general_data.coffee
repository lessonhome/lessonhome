
class @main
  forms : ['person','tutor']
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
      $form   : person : 'first_name'
    last_name   : module 'tutor/forms/input':
      replace : '[^a-zA-Zа-яА-ЯёЁ]'
      selector    : 'first_reg'
      text2       : 'Фамилия :'
      $form   : person : 'last_name'
    middle_name  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text2       : 'Отчество :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
      $form   : person : 'middle_name'
    gender_data   : state 'gender_data':
      selector        : 'choose_gender'
      title           : 'true'
      selector_button : 'registration'
      value           : $form : person : 'sex'
    birth_data    : state 'data_date'  :
      text  : 'Дата рождения :'
      day_value   : $form : person : 'birthday'
      month_value : $form : person : 'birthmonth'
      year_value  : $form : person : 'birthyear'
    status      : module 'tutor/forms/drop_down_list' :
      text        : 'Статус :'
      selector    : 'first_reg'
      scroll      : module 'tutor/forms/drop_down_list/scroll' :
        paramsData  : {} #{findContainerMethod:'prev'}
      options_count: 7
      $form : tutor : 'status'
      default_options     : {
        '0': {value: 'schoolboy', text: 'школьный учитель'},
        '1': {value: 'schoolboy', text: 'преподаватель ВУЗа'},
        '2': {value: 'student',   text: 'студент'},
        '3': {value: 'graduate',  text: 'аспирант/выпускник'},
        '4': {value: 'phd',       text: 'кандидат наук'},
        '5': {value: 'phd2',      text: 'доктор наук'}
      }



