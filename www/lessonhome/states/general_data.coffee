
class @main
  tree : -> module '$' :
    add_photos   : module 'add_photos'
    first_name  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Имя :'
      pattern     : '^[a-z]*$' #required using some like: (dataObject 'checker').patterns.alphabet
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
      #(required using some like: (dataObject 'checker').hints.alphabet)
      hint        : 'Поле должно содержать только символы русского или английского алфавита'
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
        '0': {value: 'student', text: 'студент'},
        '1': {value: 'graduate', text: 'аспирант'},
        '2': {value: 'school_teacher', text: 'школьный преподаватель'},
        '3': {value: 'high_school_teacher', text: 'преподаватель вуза'},
        '4': {value: 'private_teacher', text: 'частный преподаватель'}
      }








