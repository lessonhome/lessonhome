class @main extends @template '../main'
  route : '/about_us'
  tags  : -> 'pupil:about_us'
  model : 'main/registration'
  title : "О нас"
  access : ['other','pupil','tutor']
  tree : =>
    content: @module '$' :
      last_tutors: [
        @module '$/last_tutor' :
          subject: 'Английский язык'
          full_name: 'Иванова Е.Ю.'
        @module '$/last_tutor' :
          subject: 'Английский язык'
          full_name: 'Иванова Е.Ю.'
        @module '$/last_tutor' :
          subject: 'Английский язык'
          full_name: 'Иванова Е.Ю.'
      ]