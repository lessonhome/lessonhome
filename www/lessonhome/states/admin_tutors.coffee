
class @main
  route : '/admin/tutors'
  model : 'main/application/1_step'
  title : "админка"
  access : ['admin']
  redirect : {
    tutor : '/enter'
    pupil : '/enter'
    other : '/enter'
    default : '/enter'
  }
  tree : -> @module 'admin/tutors' :
    lib : @state 'libnm'


