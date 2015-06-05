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
        '0': {value: 'moscow', text: 'Москва'},
        '1': {value: 'saint_petersburg', text: 'Санкт-Петербург'},
        '2': {value: 'novosibirsk', text: 'Новосибирск'},
        '3': {value: 'yekaterinburg', text: 'Екатеринбург'},
        '4': {value: 'nizhny_novgorod', text: 'Нижний Новгород'},
        '5': {value: 'kazan', text: 'Казань'},
        '6': {value: 'samara', text: 'Самара'},
        '7': {value: 'chelyabinsk', text: 'Челябинск'},
        '8': {value: 'omsk', text: 'Омск'},
        '9': {value: 'rostov_on_don', text: 'Ростов-на-Дону'},
        '10': {value: 'ufa', text: 'Уфа'},
        '11': {value: 'krasnoyarsk', text: 'Красноярск'},
        '12': {value: 'perm', text: 'Пермь'},
        '13': {value: 'volgograd', text: 'Волгоград'},
        '14': {value: 'voronezh', text: 'Воронеж'},
        '15': {value: 'saratov', text: 'Саратов'},
        '16': {value: 'krasnodar', text: 'Краснодар'},
        '17': {value: 'tolyatti', text: 'Тольятти'},
        '18': {value: 'tyumen', text: 'Тюмень'},
        '19': {value: 'izhevsk', text: 'Ижевск'},
        '20': {value: 'barnaul', text: 'Барнаул'},
        '21': {value: 'ulyanovsk', text: 'Ульяновск'},
        '22': {value: 'irkutsk', text: 'Иркутск'},
        '23': {value: 'vladivostok', text: 'Владивосток'},
        '24': {value: 'yaroslavl', text: 'Ярославль'},
        '25': {value: 'khabarovsk', text: 'Хабаровск'},
        '26': {value: 'makhachkala', text: 'Махачкала'},
        '27': {value: 'orenburg', text: 'Оренбург'},
        '28': {value: 'tomsk', text: 'Томск'},
        '29': {value: 'novokuznetsk', text: 'Кемерово'},
        '30': {value: 'ryazan', text: 'Рязань'},
        '31': {value: 'astrakhan', text: 'Астрахань'},
        '32': {value: 'naberezhnye_chelny', text: 'Набережные Челны'},
        '33': {value: 'penza', text: 'Пенза'},
        '34': {value: 'lipetsk', text: 'Липецк'}
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











