class @main extends template './contacts'
  route : '/tutor/edit/contacts_address'
  model : 'tutor/profile_registration/second_step_address'
  title : "Редактирование полный адрес"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    address_popup   : state 'place_tutor'




