class @main extends @template '../main'
  route : '/cancel_subscription'
  model : 'main/second_step'
  title : "отказаться от рассылки"
  access : ['other']
  tree : =>
    filter_top : @module '$'  :
      email: 'serega.murzenok@gmail.com'
      toggle: @module 'tutor/forms/toggle' :
        first_value : 'Получать'
        second_value : 'Не получать'
        selector: 'cancel_subscription'
      cancel_reason: @module 'tutor/forms/input' :
        text1       : 'Почему Вы хотите отписаться?'
        selector  : 'fast_bid'
      cancel_button    : @module 'tutor/button' :
        selector  : 'cancel'
        text      : 'ОТПИСАТЬСЯ'
      ###
        login           : @module 'tutor/forms/input' :
          replace : [
            "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
          ]
          name        : 'email'
          selector    : 'registration'
          text1       : 'Телефон или email'
        password        : @module 'tutor/forms/input' :
          name        : 'password'
          type        : 'password'
          selector    : 'registration'
          text1       : 'Пароль'
        cancel_button    : @module 'link_button' :
          href      : 'tutor/profile/first_step'
          selector  : 'enter_office'
          text      : 'Войти'

      ###