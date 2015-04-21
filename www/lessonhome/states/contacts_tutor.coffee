class @main
  tree : -> module '$' :
    country : module 'tutor/forms/drop_down_list' :
      text        : 'Страна :'
      selector    : 'first_reg'
      default_options     : {
        '0': {value: 'russia', text: 'Россия'},
        '1': {value: 'ukraine', text: 'Украина'},
        '2': {value: 'belarus', text: 'Белоруссия'}
      }
      value : data('person').get('location').then (l)-> l?.country
    city    : module 'tutor/forms/drop_down_list' :
      text        : 'Город :'
      selector    : 'first_reg'
      default_options     : {
        '0': {value: 'moscow', text: 'Москва'},
        '1': {value: 'spb', text: 'Санкт Петербург'}
      }
      value : data('person').get('location').then (l)-> l?.city
    # var popup respond address
    address_popup   :         @exports()
    address_popup_href:       @exports()
    address_popup_close_href: @exports()

    line    : module 'tutor/separate_line' :
      selector : 'horizon'
    mobile_phone  : module 'tutor/forms/input' :
      text2      : 'Мобильный телефон :'
      selector  : 'first_reg'
      placeholder: '+7 (xxx) xxx–xx–xx'
      value: data('person').get('phone').then (p)-> p[0] if p?[0]?
    extra_phone   : module 'tutor/forms/input' :
      text2      : 'Доп. телефон :'
      selector  : 'first_reg'
      value: data('person').get('phone').then (p)-> p[1] if p?[1]?
    post          : module 'tutor/forms/input' :
      text2      : 'Почта(email) :'
      selector  : 'first_reg'
      value: data('person').get('email').then (e)-> e[0] if e?[0]?
    skype         : module 'tutor/forms/input' :
      text2      : 'Skype :'
      selector  : 'first_reg'
      value: data('person').get('social_networks').then (s)-> s.skype[0] if s?.skype?[0]?
    site          : module 'tutor/forms/input' :
      text2      : 'Личный сайт :'
      selector  : 'first_reg'
      value: data('person').get('site').then (s)-> s[0] if s?[0]?
