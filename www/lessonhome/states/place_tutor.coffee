
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
      text2      : 'Ближайшее метро :'
      selector  : 'first_reg'
    street     : module 'tutor/forms/input' :
      text2      : 'Улица :'
      selector  : 'first_reg'
    house      : module 'tutor/forms/input' :
      text2      : 'Дом :'
      selector  : 'first_reg_house'
    building   : module 'tutor/forms/input' :
      text2      : 'Строение :'
      selector  : 'first_reg_house'
    flat       : module 'tutor/forms/input' :
      text2      : 'Квартира :'
      selector  : 'first_reg_house'
    add_button : module 'tutor/button' :
      text     : '+Добавить'
      selector : 'reg_add'













