class @main extends template '../reports'
  tree : ->
    popup : module '$' :
      header       : module '//header'
      content      : @exports()   # must be defined
      footer       : module '//footer' :
        msg : module 'tutor/forms/textarea' :
          placeholder : 'Ваш комментарий'
          height : '104px'
        send_button : module 'link_button' :
          selector: 'reports_popup_send'
          text: 'Отправить'
          href: '../reports'
