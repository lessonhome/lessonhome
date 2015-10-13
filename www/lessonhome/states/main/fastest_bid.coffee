class @main
  tree: => @module '$':
    field_name : @module 'tutor/forms/input' :
      placeholder : 'Имя'
      selector: 'person issue'
      value: $urlform: pupil: 'name'
    field_phone : @module 'tutor/forms/input' :
      placeholder : 'Телефон'
      selector: 'phone issue'
      value: $urlform: pupil: 'phone'
    btn_send : @module 'link_button' :
      text : 'Подобрать!'
      selector: 'arrow fast_bid'
    btn_more : @module 'tutor/header/elem_attach' :
      trigger : 'Заполнить подробнее'

