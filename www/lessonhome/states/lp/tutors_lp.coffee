class @main  extends @template '../lp'
  route : '/tutors_lp'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Репетиторам"
  access : ['other']
  redirect : {

  }
  tree : =>
    ###
    test : $defer : =>
      taskTypes = yield Feel.getAllTaskTypes()
      ret = {}
      for type in taskTypes
        struct = yield Feel.getTaskStruct type
        ret[type] = @module 'task': struct
      return ret
    ###
    content : @module '$':
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'


