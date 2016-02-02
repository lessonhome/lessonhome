class @main extends @template '../main'
  route : '/map'
  model : 'main/second_step'
  title : "карта репетиторов"
  tags  : -> []
  access : ['other','tutor','pupil']
  tree : =>
    content : @module 'maps/all'
