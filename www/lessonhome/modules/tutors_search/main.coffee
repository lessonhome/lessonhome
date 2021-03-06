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
    @metro = yield Feel.const('metro')
    @linked = {}
    #@tutors = $.localStorage.get 'tutors'
    #@tutors ?= {}
    @loaded = {}
    @doms = {}
    #@tnum   = 10
    #@tfrom  = 0
    #@now    = []
    @filter_stations = []
    @from = 0
    @count = 10
    @changed = true
    @sending = false
    @busy = false
    @busyNext = null
    @tree.tutor_test = @tree.tutor
    @filter_data = null
    @isfirst = true
    @now = []
    for key,t of @tree.tutors
      @now.push t.value.index
      @doms[t.value.index] =
        cl : t.class
        dom : t.class.dom

  show: =>
    @metro = yield Feel.const('metro')
    @found.tutor.remove()

    #@advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll.tutors',@onscroll
    Feel.urlData.on 'change', (force) => Q.spawn =>
      @filter_stations = []
      arr = yield Feel.urlData.get('tutorsFilter','metro')
      for s in arr
        @filter_stations.push {
          metro : @metro.stations[s.split(':')[1]].name
          color : @metro.lines[s.split(':')[0]].color
          key : s.split(':')[1]
        }
      yield @apply_filter(force)
    ### TODO
    @tree.advanced_filter.apply.class.on 'submit',=> Q.spawn =>
      #top = $('#m-main-advanced_filter').offset?()?.top
      #$(window).scrollTop top-10 if top >= 0
      yield @apply_filter true
    ###
    @choose_tutors_num = @found.choose_tutors_num

    @showFilter.on 'click', =>
      @listTutors.hide(0,
        =>
          @filterBlock.show().addClass 'filterShow'
          @showFilter.hide()
      )
    @found.show_result.on 'click', =>

      $("body, html").animate {
          "scrollTop":0
        }, 0

      @filterBlock.hide(0,
        =>
          @filterBlock.removeClass 'filterShow'
          @listTutors.show()
          @showFilter.show()
      )

    #@found.demo_modal.on 'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'empty'
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
    @found.controlls?.hide?()
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
      @tree.search_help.class.pushpinIit()
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
    @found.controlls?.hide?()
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
    prep.filter_stations = @filter_stations
    @updateDom obj, prep
#    @relinkedOne cl
    return @doms[prep.index] = obj
  updateDom : (dom,prep) => dom.class.setValue(prep)
  onscroll : => Q.spawn =>
    ll = @tutors_result.find(':last')
    dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
    return if @filterBlock.hasClass 'filterShow'
    if dist >= -400
      return if (yield Feel.urlData.get('tutorsFilter','offset'))!=0
      yield @addTen()
  apply_filter : (force=false)=> do Q.async =>
    return @isfirst = false if @isfirst
    @linked = yield Feel.urlData.get 'mainFilter','linked'
    #yield @setFiltered()
    @hashnow ?= 'null'
    filter = yield @toOldFilter()
    console.log filter
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

    
  relinkedOne: (cl) => cl.tree?.class?.setLinked @linked
  relinkedAll: => for index, el of @doms then @relinkedOne el.class




