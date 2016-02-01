

class @main
  access : ['tutor','pupil','other']
  redirect : {}
  forms : [{'person':['first_name']}]
  route :  '/test/urls'
  extends : './2'
  tree : =>
    value1 : @module 'dev/urls' :
      depend : [
        @state './3' :
          bobobo : "bobobo"
        @module 'lib/mousewheel'
      ]
      user : $form :person:"first_name"

