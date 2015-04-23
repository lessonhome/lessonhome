
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
      selector   : 'first_reg'
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
    add_button : module 'button_add' :
      text      : '+Добавить'
      selector  :  'edit_add'
    save_button : module 'link_button' :
      text      : 'Сохранить'
      selector  :  'edit_save'
      href      :  '/tutor/profile/second_step'

  init: =>
    location = data('person').get('location')
    console.log location
    console.log '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    #@tree.country.value = data('person').get('location').then (l)-> l?.country
    @tree.country.value = location.then (l)-> l?.country
    @tree.city.value = location.then (l)-> l?.city
    @tree.area.value = location.then (l)-> l?.area
    @tree.near_metro.value = location.then (l)-> l?.metro
    @tree.street.value = location.then (l)-> l?.street
    @tree.house.value = location.then (l)-> l?.house
    @tree.building.value = location.then (l)-> l?.building
    @tree.flat.value = location.then (l)-> l?.flat

    #data = data('person').getAll()
    #console.log data














