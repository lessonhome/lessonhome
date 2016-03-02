


class @main
  Dom : =>

  show : =>
    @clone = @tree.tutors[0].class.$clone()
    for button in @found.yt_button
      yield @yt_button $ button

  yt_button : (button)=> Q.spawn =>
    u = button.attr('hr')
    l1 = u+'&qw=2'
    l2 = u+'&qw=1'
    _preps = {}
    _ids = []
    for l in [l1,l2]
      from = l?.match(/qi\=(\d+)/)?[1] || 0
      from = +from
      l = yield @toOldFilter l
      indexes = yield Feel.dataM.getTutors from,2,l
      ids = indexes.slice from,from+2
      _ids = [_ids...,ids...]
      preps = yield Feel.dataM.getTutor ids
      for key,val of preps
        _preps[key] = val
    _ids.sort (a,b)=> _preps[a].left_price-_preps[b].left_price
    d = 200
    button.click => Q.spawn =>
      @found.tutor_list.animate {'opacity':0},d
      @found.yt_button.removeClass 'ytb__active'
      button.addClass 'ytb__active'
      yield Q.delay d
      arr = []
      for id in _ids
        o = @clone.$clone()
        yield o.setValue _preps[id]
        arr.push o
      @found.tutor_list.empty()
      for a in arr
        @found.tutor_list.append a.dom
      @found.tutor_list.animate {'opacity':1},d
      
    
    
  toOldFilter : (u)=>
    filters = yield Feel.urlData.udata.u2d u
    olds = filters.mainFilter
    filters = filters.tutorsFilter
    mf = {}
    mf.page = 'filter'
    mf.subject = filters.subjects

    ss = {}
    mf.subject ?= []
    for s in mf.subject
      ss[s] = true
    if olds.subject[0]
      for s in olds.subject
          ss[s] = true
    mf.progress = true
    mf.subject = Object.keys ss
    mf.course = filters.course ? []
    ss = []
    for c in mf.course
      ss[c] = true
    for c in (olds.course ? [])
      ss[c] = true
    mf.metro ?= {}
    for m in (filters.metro ? [])
      m_path = m?.split?(':')?[1] || ""
      mf.metro[m_path] = true if m_path
      m = @metro.stations?[m?.split?(':')?[1] ? ""]?.name
      #ss[m] = true if m
    mf.course = Object.keys ss
    l = 500
    r = 6000
    if filters.price?["до 700 руб."]
      if filters.price?["от 700 руб. до 1500 руб."]
        unless filters.price?["от 1500 руб."] then    r = 1500
      else unless filters.price?["от 1500 руб."] then r = 700
    else
      if filters.price?["от 700 руб. до 1500 руб."]
        l = 700
        unless filters.price?["от 1500 руб."] then r = 1500
      else if filters.price?["от 1500 руб."]  then l = 1500
    mf.price =
      left : l
      right : r
    mf.tutor_status ={}
    mf.tutor_status.student=true if filters.status['Студент']
    mf.tutor_status.native_speaker=true if filters.status['Носитель языка']
    mf.tutor_status.university_teacher=true if filters.status['Преподаватель ВУЗа']
    mf.tutor_status.school_teacher=true if filters.status['Преподаватель школы']
    mf.tutor_status.private_teacher=true if filters.status['Частный преподаватель']
    switch filters.sex
      when 'Мужской'
        mf.gender = 'male'
      when 'Женский'
        mf.gender = 'female'
      else
        mf.gender = ''
    #mf.course.push (filters.metro ? [])...
    mf = yield Feel.urlData.udata.d2u {'mainFilter':mf}
    return mf


