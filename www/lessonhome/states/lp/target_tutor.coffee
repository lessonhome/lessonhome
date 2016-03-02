class @main
  tree : =>@module 'lp/landing_page/target_tutor':
    tutors : $defer : =>
      #filter = yield Feel.udata.d2u "mainFilter",{}
      filter = 'o=%D0%B0%D0%BD%D0%B3%D0%BB%D0%B8%D0%B9%D1%81%D0%BA%D0%B8%D0%B9%20%D1%8F%D0%B7%D1%8B%D0%BA&e&qo&f=6000'
      hash = yield Feel.udata.filterHash filter,'filter'
      filter = yield Feel.udata.u2d filter
      jobs = yield Main.service 'jobs'
      o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:4,from:0}
      o ?= {}
      o.preps ?= {}

      modules = for index,prep of o.preps
        {
          module:@module 'lp/landing_page/tutors_mini':
            value:prep
          price : prep.left_price
        }
      modules.sort (a,b)-> return a.price - b.price
      ret = for m in modules then m.module
      return ret

