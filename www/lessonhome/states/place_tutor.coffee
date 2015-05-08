
class @main
  forms : [{person:['location']}]
  tree : -> module '$' :
    country : module 'tutor/forms/drop_down_list' :
      text      : 'Страна :'
      selector  : 'first_reg'
      default_options     : {
        '0': {value: 'russia', text: 'Россия'}
    }
      $form : person : 'location.country'
    city    : module 'tutor/forms/drop_down_list' :
      text      : 'Город :'
      selector  : 'first_reg'
      default_options     : {
        '0': {value: 'moscow', text: 'Москва'}
      }
      $form : person : 'location.city'
    area    : module 'tutor/forms/drop_down_list' :
      text      : 'Район :'
      selector  : 'first_reg'
      $form : person : 'location.area'
    near_metro : module 'tutor/forms/input' :
      text2      : 'Ближайшее метро :'
      selector   : 'first_reg'
      $form : person : 'location.metro'
    street     : module 'tutor/forms/input' :
      text2      : 'Улица :'
      selector  : 'first_reg'
      $form : person : 'location.street'
    house      : module 'tutor/forms/input' :
      text2      : 'Дом :'
      selector  : 'first_reg'
      $form : person : 'location.house'
    building   : module 'tutor/forms/input' :
      text2      : 'Строение :'
      selector  : 'first_reg'
      $form : person : 'location.building'
    flat       : module 'tutor/forms/input' :
      text2      : 'Квартира :'
      selector  : 'first_reg'
      $form : person : 'location.flat'
    save_button : module 'link_button' :
      text      : 'Сохранить'
      selector  :  'edit_save'
      href      :  '/tutor/profile/second_step'

