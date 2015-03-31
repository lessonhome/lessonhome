
class @main
  tree : -> module '$' :
    add_photos   : module 'add_photos'
    first_name  : module 'tutor/forms/input':
      level2left : 'Имя :'
      selector    : 'first_reg'
      text        : 'Имя :'
      pattern     : '^[a-z]*$' #required using some like: (dataObject 'checker').patterns.alphabet
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
      #(required using some like: (dataObject 'checker').hints.alphabet)
      hint        : 'Поле должно содержать только символы русского или английского алфавита'
      replace     : [
        "^\\s+"
        "\\s+$"
        "d": "a"
      ]
      replace     : [
        "^(8|7)(?!\\+7)":"+7"
        "^(.*)(\\+7)":"$2$1"
        "\\+7"
        "[^\\d_]"
        {"^(.*)$":"$1__________"}
        {"^([\\d_]{0,10})(.*)$": "$1"}
        {"^([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)$":"+7 ($1$2$3) $4$5$6-$7$8-$9$10"}
      ]
      replaceCursor     : [
        "(_)"
      ]
      selectOnFocus : true
    last_name   : module 'tutor/forms/input':
      replace : '[^a-zA-Zа-яА-ЯёЁ]'
      selector    : 'first_reg'
      level2left        : 'Фамилия :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
    patronymic  : module 'tutor/forms/input':
      selector    : 'first_reg'
      level2left        : 'Отчество :'
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
      scroll      : module 'tutor/forms/drop_down_list/scroll' :
        paramsData  : {} #{findContainerMethod:'prev'}
      options_count: 7

      default_options     : {
        '0': {value: 'math', text: 'Преподаватель(тест)'},
        '1': {value: 'student', text: 'Студент(тест)'},
        '2': {value: 'aspirant', text: 'Аспирант(тест)'},
        '3': {value: 'advokat', text: 'Адвокат(тест)'},
        '4': {value: 'test-status1', text: 'Тестовый статус 1'},
        '5': {value: 'test-status2', text: 'Тестовый статус 2'},
        '6': {value: 'test-status3', text: 'Тестовый статус 3'},
        '7': {value: 'test-status4', text: 'Тестовый статус 4'},
        '8': {value: 'test-status4', text: 'Тестовый статус 5'},
        '9': {value: 'test-status4', text: 'Тестовый статус 6'},
        '10': {value: 'test-status4', text: 'Тестовый статус 7'},
        '11': {value: 'test-status4', text: 'Тестовый статус 8'},
        '12': {value: 'test-status4', text: 'Тестовый статус 9'},
        '13': {value: 'test-status4', text: 'Тестовый статус 10'},
      }











