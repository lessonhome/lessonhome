class @main extends @template '../main'
  route : '/about_us'
  tags  : -> 'pupil:about_us'
  model : 'main/registration'
  title : "О нас"
  access : ['other','pupil','tutor']
  tree : =>
    content: @module '$' :
      reg_button: @module 'link_button' :
        selector: 'about_us'
        text: 'ЗАРЕГИСТРИРОВАТЬСЯ'
        