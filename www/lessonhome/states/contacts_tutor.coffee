class @main
  forms : [{person:['country','city','phone','phone2','skype','email','site']}]
  tree : -> module '$' :
    country : module 'tutor/forms/drop_down_list' :
      text        : 'Страна :'
      selector    : 'first_reg'
      default_options     : {
        '0': {value: 'russia', text: 'Россия'}
      }
      value : $form : person : 'country'
    city    : module 'tutor/forms/drop_down_list' :
      text        : 'Город :'
      selector    : 'first_reg'
      default_options     : {
        '0': {value: 'moscow', text: 'Москва'}
      }
      value : $form : person : 'city'
    # var popup respond address
    address_popup   :         @exports()
    href        : @exports()
    href_back   : @exports()

    line    : module 'tutor/separate_line' :
      selector : 'horizon'
    mobile_phone  : module 'tutor/forms/input' :
      text2      : 'Мобильный телефон :'
      selector  : 'first_reg'
      placeholder: '+7 (xxx) xxx–xx–xx'
      value: $form : person : 'phone'
      #p[0] if p?[0]?
      replace     : [
        {"^(8|7)(?!\\+7)":"+7"}
        {"^(.*)(\\+7)":"$2$1"}
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
      patterns : [
        "^\\+7 \\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d-\\d\\d$" : "Введите телефон <br>в формате +7 (926) 123-45-45"
      ]


    extra_phone   : module 'tutor/forms/input' :
      text2      : 'Доп. телефон :'
      selector  : 'first_reg'
      value: $form : person : 'phone2'
    post          : module 'tutor/forms/input' :
      text2      : 'Почта(email) :'
      selector  : 'first_reg'
      value: $form : person : 'email'
    skype         : module 'tutor/forms/input' :
      text2      : 'Skype :'
      selector  : 'first_reg'
      value: $form : person : 'skype'
    site          : module 'tutor/forms/input' :
      text2      : 'Личный сайт :'
      selector  : 'first_reg'
      value: $form : person : 'site'












