class @main extends @template '../main'
  route : '/all'
  model : 'main/second_step'
  title : "карта репетиторов"
  tags  : -> []
  access : ['other','tutor','pupil']
  tree : =>
    content : @module 'maps/all'
