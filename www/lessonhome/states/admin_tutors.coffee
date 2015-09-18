
class @main
  route : '/admin/tutors'
  model : 'main/application/1_step'
  title : "админка"
  access : ['admin']
  tree : -> @module 'admin/tutors'


