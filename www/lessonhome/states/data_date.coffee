
class @main
  tree : => @module '$' :
    day   : @module 'tutor/forms/drop_down_list' :
      text        : @exports()
      placeholder : 'День'
      selector    : 'first_reg_day'
      filter      : true
      items       : [1..31]
      value : @exports 'day_value'
    month : @module 'tutor/forms/drop_down_list' :
      filter      : true
      placeholder : 'Месяц'
      selector    : 'first_reg_month'
      default_options     : {
        '0': {value: 'january', text: 'январь'},
        '1': {value: 'february', text: 'февраль'},
        '2': {value: 'march', text: 'март'},
        '3': {value: 'april', text: 'апрель'},
        '4': {value: 'may', text: 'май'},
        '5': {value: 'june', text: 'июнь'},
        '6': {value: 'july', text: 'июль'},
        '7': {value: 'august', text: 'август'},
        '8': {value: 'september', text: 'сентябрь'},
        '9': {value: 'october', text: 'октябрь'},
        '10': {value: 'november', text: 'ноябрь'},
        '11': {value: 'december', text: 'декабрь'}
      }
      value: @exports 'month_value'
    year  : @module 'tutor/forms/drop_down_list' :
      filter : true
      placeholder : 'Год'
      selector    : 'first_reg_month'
      items : [1997..1916]
      value: @exports 'year_value'


