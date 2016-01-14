class @main extends @template 'lp'
  route : '/'
  model : 'main_m'
  title : "LessonHome - Главная страница"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : =>
    filter = @const('filter')
    content : @module '$':
      subject_list: filter.subjects
      training_direction : filter.course
      value : $urlform : pupil: ''
      main_rep : $defer : =>
        maxl = 170
        jobs = yield Main.service 'jobs'
        prep = yield jobs.solve 'getTutorsOnMain', 4
        for p in prep
          continue unless p.reviews.length
          onmain = []
          i = 0
          while i < p.reviews.length
            p.reviews.splice(i--, 1) unless p.reviews[i].review
            tutor_text = p.reviews[i].review.substr 0,maxl
            tutor_text = tutor_text.replace /\s+[^\s]*$/gim,''
            p.reviews[i].review = tutor_text + '... '
            onmain.push i if p.reviews[i].onmain
            i++
          onmain = Object.keys(p.reviews) unless onmain.length

          if onmain.length is 1
            p['num_show_rev'] = onmain[0]
          else
            p['num_show_rev'] = onmain[Math.floor(Math.random()*onmain.length)]

          p.avatar = p.photos[p.photos.length - 1].lurl
          p.link = '/tutor_profile?'+yield Feel.udata.d2u 'tutorProfile',{index:p.index}

        return prep
