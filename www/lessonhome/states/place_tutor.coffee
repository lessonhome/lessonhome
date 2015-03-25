
class @main
  tree : -> module '$' :
    country : module 'tutor/forms/drop_down_list' :
      text      : 'Страна :'
      selector  : 'first_reg'
    city    : module 'tutor/forms/drop_down_list' :
      text      : 'Город :'
      selector  : 'first_reg'
    area    : module 'tutor/forms/drop_down_list' :
      text      : 'Район :'
      selector  : 'first_reg'
    near_metro : module 'tutor/forms/input' :
      text      : 'Ближайшее метро :'
      selector  : 'first_reg'
    street     : module 'tutor/forms/input' :
      text      : 'Улица :'
      selector  : 'first_reg'
    house      : module 'tutor/forms/input' :
      text      : 'Дом :'
      selector  : 'first_reg_house'
    building   : module 'tutor/forms/input' :
      text      : 'Строение :'
      selector  : 'first_reg_house'
    flat       : module 'tutor/forms/input' :
      text      : 'Квартира :'
      selector  : 'first_reg_house'
    add_button : module 'tutor/button' :
      text     : '+Добавить'
      selector : 'reg_add'













