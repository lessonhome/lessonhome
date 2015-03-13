
class @main
  tree : -> module '$' :
    first_name  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Имя :'
      pattern     : '^[a-z]*$' #required using some like: (dataObject 'checker').patterns.alphabet
    last_name   : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Фамилия :'
    patronymic  : module 'tutor/forms/input':
      selector    : 'first_reg'
      text        : 'Отчество :'
    gender_data   : state 'gender_data'
    birth_data    : state 'birth_data'  :
      text  : 'Дата рождения :'
    status      : module 'tutor/forms/drop_down_list' :
      text        : 'Статус :'
      selector    : 'first_reg'












