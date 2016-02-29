class @main
  tree : =>@module 'lp/landing_page/target_tutor':
    tutors : $defer : =>
      filter = yield Feel.udata.d2u "mainFilter",{}
      hash = yield Feel.udata.filterHash filter,'filter'
      filter = yield Feel.udata.u2d filter
      jobs = yield Main.service 'jobs'
      o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:4,from:0}
      o ?= {}
      o.preps ?= {}
      modules = for index,prep of o.preps
        @module 'lp/landing_page/tutors_mini':
          value:prep
      return modules

