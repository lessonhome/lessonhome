class @main extends @template '../errors/404'
  route : '/about_us'
  tags  : -> 'pupil:about_us'
  model : 'main/registration'
  title : "О нас"
  access : ['other','pupil','tutor']
  #tree : ->