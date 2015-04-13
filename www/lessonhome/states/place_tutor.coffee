
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
      selector  : 'first_reg'
    building   : module 'tutor/forms/input' :
      text2      : 'Строение :'
      selector  : 'first_reg'
    flat       : module 'tutor/forms/input' :
      text2      : 'Квартира :'
      selector  : 'first_reg'
    save_button : module 'link_button' :
      text      : 'Сохранить'
      selector  :  'fast_bid_nav'
      href      :  '/tutor/profile/second_step'
















