
class @main
  forms : ['person','tutor']
  tree : => @module '$' :
    add_photos   : @module 'add_photos' :
      depend : [
        @module 'lib/jquery/ui_widget'
        @module 'lib/jquery/iframe_transport_plugin'
        @module 'lib/jquery/fileupload'
      ]
      $form : person : avatar : 'photo'
    first_name  : @module 'tutor/forms/input':
      text2 : 'Имя :'
      selector    : 'first_reg'
      hint        : 'Поле должно содержать только символы русского или английского алфавита'
      $form   : person : 'first_name'
    last_name   : @module 'tutor/forms/input':
      replace : '[^a-zA-Zа-яА-ЯёЁ]'
      selector    : 'first_reg'
      text2       : 'Фамилия :'
      $form   : person : 'last_name'
    middle_name  : @module 'tutor/forms/input':
      selector    : 'first_reg'
      text2       : 'Отчество :'
      allowSymbolsPattern : '[a-zA-Zа-яА-ЯёЁ]'
      $form   : person : 'middle_name'
    gender_data   : @state 'gender_data':
      selector        : 'choose_gender'
      title           : 'true'
      selector_button : 'registration'
      value           : $form : person : 'sex'
    birth_data    : @state 'data_date'  :
      text  : 'Дата рождения :'
      day_value   : $form : person : 'birthday'
      month_value : $form : person : 'birthmonth'
      year_value  : $form : person : 'birthyear'
    status      : @module 'tutor/forms/drop_down_list' :
      text        : 'Статус :'
      selector    : 'first_reg'
      $form : tutor : 'status'
      items : ['Студент','Преподаватель школы','Преподаватель ВУЗа','Частный преподаватель','Носитель языка']


