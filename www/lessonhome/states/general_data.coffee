
class @main
  tree : -> module '$' :
    first_name  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Имя :'
      pattern     : '^[a-z]*$' #required using some like: (dataObject 'checker').patterns.alphabet
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
    last_name   : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Фамилия :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
    patronymic  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Отчество :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
    gender_data   : state 'gender_data':
      selector        : 'choose_gender'
      title           : 'true'
      selector_button : 'registration'
    birth_data    : state 'birth_data'  :
      text  : 'Дата рождения :'
    status      : module 'tutor/forms/drop_down_list' :
      text        : 'Статус :'
      selector    : 'first_reg'
      default_options     : {
        '0': {value: 'math', text: 'преподаватель(тест)'},
        '1': {value: 'student', text: 'студент(тест)'},
        '2': {value: 'aspirant', text: 'аспирант(тест)'},
        '3': {value: 'advokat', text: 'адвокат(тест)'}
      }











