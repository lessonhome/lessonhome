
class @main
  tree : -> module '$' :
    birth_day   : module 'tutor/forms/drop_down_list' :
      text        : @exports()
      placeholder : 'День'
      selector    : 'first_reg day'
    birth_month : module 'tutor/forms/unable_enter_list' :
      placeholder : 'Месяц'
      selector    : 'first_reg_size'
      type : 'unable_to_enter'
      list : [
        'Январь'
        'Февраль'
        'Март'
        'Апрель'
        'Май'
        'Июнь'
        'Июль'
        'Август'
        'Сентябрь'
        'Октябрь'
        'Ноябрь'
        'Декабрь'
      ]
    birth_year  : module 'tutor/forms/drop_down_list' :
      placeholder : 'Год'
      selector    : 'first_reg_size'