class @main
  constructor : ->
    $W @
  Dom : =>
    @loadedTime = new Date().getTime()
    @showFilter   = @found.show_filter
    @filterBlock  = @found.filter_block
    @listTutors   = @found.list_tutors
    @tutors_result= @found.tutors_list
    @filterStatus = 0
    @linked = {}
    #@tutors = $.localStorage.get 'tutors'
    #@tutors ?= {}
    @loaded = {}
    @doms = {}
    #@tnum   = 10
    #@tfrom  = 0
    #@now    = []
    @changed = true
    @sending = false
    @busy = false
    @busyNext = null
    @tree.tutor_test = @tree.tutor
    @filter_data = null
  show: =>
    @found.tutors_list.find('>div').remove()

    #@advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll.tutors',@onscroll
    Feel.urlData.on 'change', (force) => Q.spawn =>
      yield @apply_filter(force)
    ### TODO
    @tree.advanced_filter.apply.class.on 'submit',=> Q.spawn =>
      #top = $('#m-main-advanced_filter').offset?()?.top
      #$(window).scrollTop top-10 if top >= 0
      yield @apply_filter true
    ###
    @choose_tutors_num = @found.choose_tutors_num

    @showFilter.on 'click', (e)=>
      thisShowButton = e.currentTarget
      if(@filterStatus == 0)
        $(thisShowButton).html('Подобрать репетиторов')
        $(@filterBlock).slideDown('fast')
        $(@listTutors).slideUp('fast')
        @filterStatus = 1
      else
        $(thisShowButton).html('Подобрать по параметрам')
        $(@filterBlock).slideUp('fast')
        $(@listTutors).slideDown('fast')
        @filterStatus = 0

    @found.demo_modal.on 'click', => Q.spawn => Feel.jobs.solve 'openBidPopup'

  ###
  numTutors = 5
  tutors = yield Feel.dataM.getByFilter numTutors, ({subject:['Русский язык']})
  tutors ?= []
  if tutors.length < numTutors
    newt = yield Feel.dataM.getByFilter numTutors*2, ({})
    exists = {}
    for t in tutors
      exists[t.index]= true
    i = 0
    while tutors.length < numTutors
      t = newt[i++]-height
      break unless t?
      continue if exists[t.index]
      tutors.push t
  for tutor,i in tutors
    clone = @tree.tutor.class.$clone()
    clone.dom.css opacity:0
    @found.tutors_list.append clone.dom
    yield clone.setValue tutor
    clone.dom.show()
    clone.dom.animate (opacity:1),1400
  ###
  showLoader : =>
    @hideEmpty()
    @found.wait.show()
  hideLoader : =>@found.wait.hide()
  fixLoader : => @found.wait.addClass('abs')
  unfixLoader: =>@found.wait.removeClass('abs')
  showEmpty : =>
    @hideLoader()
    @found.not_exist.show()
  hideEmpty : => @found.not_exist.hide()
  reshow : =>
    @fixLoader()
    @showLoader()
    end = =>
      @tutors_result.css 'opacity',1
    return (@busyNext = {f:@reshow}) if @busy
    @tutors_result.css 'opacity',0
    @htime = new Date().getTime()
    @busy = true
    @from   ?= 0
    @count  = 10
    @now ?= []
    fhash = yield @toOldFilter()
    indexes = yield Feel.dataM.getTutors @from,@count,fhash
    num = indexes.length
    yield Q.delay(10)
    indexes = indexes.slice @from,@from+@count

    ### TODO
    if indexes.length is 0
      @message_empty.fadeIn 400
    else
      @message_empty.fadeOut 400
    ###
    preps   = yield Feel.dataM.getTutor indexes
    #tutors = yield Feel.dataM.getByFilter numTutors, ({subject:['Русский язык']})
    yield Q.delay(10)
    #return end() if objectHash(@now) == objectHash(indexes)
    @now = indexes
    htime = 400-((new Date().getTime())-@htime)
    #htime = 0 if htime < 0
    setTimeout (=> Q.spawn =>
      @dom.height @dom.height()
      @tutors_result.children().remove()
      @showEmpty() unless indexes.length
      yield Q.delay(10)
      for key,val of @doms
        delete @doms[key]
      for i in indexes
        p = preps[i]
        d = @createDom p
        d.dom.appendTo @tutors_result
        yield Q.delay(10)
      @hideLoader()
      @unfixLoader()
      @tutors_result.css 'opacity',1
      @dom.css 'height', ''
      yield @BusyNext()
    ),htime
  BusyNext : => do Q.async =>
    @busy = false
    if @busyNext?
      bn = @busyNext
      @busyNext = null
      yield bn.f (bn.a ? [])...
  addTen : => do Q.async =>
    return if @busy
    @busy = true
    @now ?= []
    fhash = yield @toOldFilter()
    indexes = yield Feel.dataM.getTutors @from,@count+10,fhash
    return yield @BusyNext() if indexes.length<=@count
    yield Q.delay(10)
    @count = Math.min(indexes.length-@from,@count+10)
    indexes = indexes.slice @from,@from+@count
    preps   = yield Feel.dataM.getTutor indexes
    yield Q.delay(10)
    return yield @BusyNext() if objectHash(@now) == objectHash(indexes)
    for i in [@now.length...indexes.length]
      p = preps[indexes[i]]
      d = @createDom p
      d.dom.css 'opacity' , 0
      d.dom.appendTo @tutors_result
      d.dom.css 'transition','opacity 400ms ease-out'
      yield Q.delay(10)
      d.dom.css 'opacity',1
    @now = indexes
    yield @BusyNext()
  createDom : (prep)=>
    return @doms[prep.index] if @doms[prep.index]?
    cl = @tree.tutor_test.class.$clone()
    obj =
      class : cl
      dom   : cl.dom
    @updateDom obj, prep
#    @relinkedOne cl
    return @doms[prep.index] = obj
  updateDom : (dom,prep) => dom.class.setValue(prep)
  onscroll : => Q.spawn =>
    ll = @tutors_result.find(':last')
    dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
    if dist >= -400
      yield @addTen()
  apply_filter : (force=false)=> do Q.async =>
    @linked = yield Feel.urlData.get 'mainFilter','linked'
    #yield @setFiltered()
    @hashnow ?= 'null'
    filter = yield @toOldFilter()
    hashnow = yield Feel.urlData.filterHash url:"blabla?"+filter
    return if (@hashnow == hashnow) && !force
    @hashnow = hashnow
    unless force
      if (new Date().getTime() - @loadedTime)>(1000*5)
        Feel.sendActionOnce 'tutors_filter',1000*60*20
    @changed = true
    yield @reshow()
  toOldFilter : =>
    filters = yield Feel.urlData.get 'tutorsFilter'
    @tree.tutor_test.class.setFilter? filters
    olds = yield Feel.urlData.get 'mainFilter'
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
    mf.subject = Object.keys ss
    mf.course = filters.course ? []
    ss = []
    for c in mf.course
      ss[c] = true
    for c in (olds.course ? [])
      ss[c] = true
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

    
  relinkedOne: (cl) => cl.tree?.class?.setLinked @linked
  relinkedAll: => for index, el of @doms then @relinkedOne el.class




