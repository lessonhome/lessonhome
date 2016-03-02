class @main
  tree : =>@module 'lp/comments':
    carousel : @module 'lib/jquery/plugins/slick'
    not_page_refresh: @exports()
    main_rep : $defer : =>
      maxl = 200
      jobs = _HelperJobs
      prep = yield jobs.solve 'getTutorsOnMain', 16
      prep?= []
      regexp = /\s+[^\s]*$/
      regexp_dot = /\s*\.{1,3}$/
      qs = for p in prep then do (p)=> do Q.async =>
        p.avatar = p.photos[p.photos.length - 1].lurl
        p.link = '/tutor?'+yield Feel.udata.d2u 'tutorProfile',{index:p.index}
        return unless p?.reviews?.length
        onmain = []
        i = 0
        while i < p.reviews.length
          p.reviews.splice(i--, 1) unless p.reviews[i].review
          if p.reviews[i].review.length > maxl
            tutor_text = p.reviews[i].review.substr 0, maxl
            tutor_text = tutor_text.replace regexp,''
            tutor_text = tutor_text.replace regexp_dot,''
            p.reviews[i].review = tutor_text + '... '
          onmain.push i if p.reviews[i].onmain
          i++
        onmain = Object.keys(p.reviews) unless onmain?.length

        if onmain?.length is 1
          p['num_show_rev'] = onmain[0]
        else
          p['num_show_rev'] = onmain[Math.floor(Math.random()*onmain.length)]
      yield Q.all qs
      return prep
