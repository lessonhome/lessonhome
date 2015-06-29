class @main extends @template '../registration_popup/second_step'
  route : '/tutor/profile/second_step_address'
  model : 'tutor/profile_registration/second_step_address'
  title : "Регистрация : шаг2_адрес"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    address_popup   : @state 'place_tutor'

      



