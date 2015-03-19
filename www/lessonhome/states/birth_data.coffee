
class @main
  tree : -> module '$' :
    birth_day   : module 'tutor/forms/drop_down_list' :
      text        : @exports()
      placeholder : 'День'
      selector    : 'first_reg day'
    birth_month : module 'tutor/forms/drop_down_list' :
      placeholder : 'Месяц'
      selector    : 'first_reg month'
    birth_year  : module 'tutor/forms/drop_down_list' :
      placeholder : 'Год'
      selector    : 'first_reg month'