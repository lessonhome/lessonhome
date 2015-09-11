
class @main extends EE
  constructor : ->
  Dom : => #do Q.async =>
    @loadedTime = new Date().getTime()
    @background_block  = $ @found.background_block
    @popup             = @found.popup
    @sort              = @tree.sort.class
    @test              = @found.test
    @tutors_result     = @found.tutors_result
    @profiles_20       = @found.profiles_20
    @profiles_40       = @found.profiles_40
    @profiles_60       = @found.profiles_60
    @profiles_80       = @found.profiles_80
    @reset_all_filters = @found.reset_all_filters
    @advanced_filter   = @tree.advanced_filter.class
    @message_empty     = @sort.found.message_empty
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
    #@tree.issue_bid_button.class.on 'submit',=> Feel.go '/fast_bid/first_step'
    #yield @filter()
    #yield Feel.urlData.request()
    #yield @filter()
  reshow : => do Q.async =>
    end = =>
      @tutors_result.css 'opacity',1
    return (@busyNext = {f:@reshow}) if @busy
    @tutors_result.css 'opacity',0
    @htime = new Date().getTime()
    @busy = true
    @from   ?= 0
    @count  = 10
    @now ?= []
    indexes = yield Feel.dataM.getTutors @from,@count
    num = indexes.length
    @sort.setNumber num
    yield Q.delay(10)
    indexes = indexes.slice @from,@from+@count
    @message_empty.css {
      opacity:
        if indexes.length
          0
        else
          1
    }
    preps   = yield Feel.dataM.getTutor indexes
    yield Q.delay(10)
    #return end() if objectHash(@now) == objectHash(indexes)
    @now = indexes
    htime = 400-((new Date().getTime())-@htime)
    #htime = 0 if htime < 0
    setTimeout (=> Q.spawn =>
      @tutors_result.children().remove()
      yield Q.delay(10)
      for key,val of @doms
        delete @doms[key]
      for i in indexes
        p = preps[i]
        d = @createDom p
        d.dom.appendTo @tutors_result
        yield Q.delay(10)
      @tutors_result.css 'opacity',1
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
    indexes = yield Feel.dataM.getTutors @from,@count+10
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
    @doms[prep.index] =
      class : cl
      dom   : $('<div class="tutor_result"></div>').append cl.dom
    @updateDom @doms[prep.index],prep
    return @doms[prep.index]
  updateDom : (dom,prep)=>
    dom.class.setValue prep
  ###
  reshow : => do Q.async =>
    @_reshow ?= 0
    @_reshow = 2 if @_reshow == 1
    return _waitFor @,'reshow' if @_reshow > 1
    @_reshow = 1

    @domnowi = 0
    @domnow  = null

    #hash = yield Feel.urlData.filterHash()
    #@loaded[hash] ?= {}
    #@loaded[hash].count ?= 0
    #@loaded[hash].from  ?= 0
    #@loaded[hash].tutors ?= []
    #@loaded[hash].reloaded ?= false
    #unless @loaded[hash].reloaded
    #  @loaded[hash].reloading = Feel.BTutors.request {count:@tnum,from:@tfrom}
    #if (@loaded[hash].from > @tfrom) || ((@loaded[hash].from+@loaded[hash].count)<(@tfrom+@tnum))
    #  @loaded[hash].tutors = yield @filter2()
    #yield @show2 @loaded[hash]
    
    #unless @loaded[hash].reloaded
    #  yield @loaded[hash].reloading
    #  @loaded[hash].reloaded = true
    #  @loaded[hash].tutors = yield @filter2()
    #  yield @show2 @loaded[hash]

    #if @_reshow == 2
    #  @_reshow = 0
    #  return @reshow()
    #@_reshow = 0

  filterChange : => do Q.async =>
    @fchange ?= 0
    return if @fchange > 1
    if @fchange == 1
      @fchange = 2
      return
    @fchange = 1
    yield Q.delay 1
    yield @filter()
    yield Q.delay 1
    yield @request()
    if @fchange == 2
      @fchange = 0
      return @filterChange()
    @fchange = 0
  ###
  setFiltered : => do Q.async =>
    set_ = (n,t,name=n,val=[])=>
      unless t
        @found['t'+n].parent().off()
        return @found['t'+n].parent().hide()
      @found['t'+n].parent().click =>
        o = {}
        o[name]=val
        Feel.urlData.set('mainFilter',o).done()
      @found['t'+n].text(t)
      @found['t'+n].parent().show()
    mf = yield Feel.urlData.get 'mainFilter'
    console.log mf
    if mf.subject.length
      set_ 'subject','Предмет: '+mf.subject.join ', '
      subject = true
    else
      subject = false
      set_ 'subject'
    if mf.course.length
      set_ 'course','Направление: '+mf.course.join ', '
      course = true
    else
      course = false
      set_ 'course'
    if subject || course
      @advanced_filter.activate 'subject',true
    else
      @advanced_filter.activate 'subject',false
     
  show : =>
    @advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll',=>
      ll = @tutors_result.find(':last')
      dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
      if dist >= -400
        @addTen().done()
    @on 'change', =># Q.spawn =>
      if (new Date().getTime() - @loadedTime)>(1000*5)
        Feel.sendActionOnce 'tutors_filter',1000*60*2
      #@changed = true
      #@tnum = 4
      #@reshow().done()
    Feel.urlData.on 'change',=> Q.spawn =>
      @setFiltered().done()
      @hashnow ?= 'null'
      hashnow = yield Feel.urlData.filterHash()
      return if @hashnow == hashnow
      @hashnow = hashnow
      @changed = true
      yield @reshow()

    ###
    @tutors_result = @tree.tutors_result
    ###
    @choose_tutors_num = @found.choose_tutors_num
    ###
    @tutors_result[1].tutor_extract.class.found.add_button_bid.on 'click', =>
      @imgtodrag = $($('.photo')[1]).eq(0)
      if @imgtodrag
        @imgclone = @imgtodrag.clone()
        @imgclone.offset({
          top:  @imgtodrag.offset().top
          left: @imgtodrag.offset().left
        })
        @imgclone.css({
            'opacity': '0.5',
            'position': 'absolute',
            'height': '150px',
            'width': '150px',
            'z-index': '100'
          })
    ###
    @sort.on 'change',  => @emit 'change'


    @background_block.on 'click',  @check_place_click

    $(@profiles_20).on 'click', =>
      @setItemActive   @profiles_20
      @setItemInactive @profiles_40
      @setItemInactive @profiles_60
      @setItemInactive @profiles_80

    $(@profiles_40).on 'click', =>
      @setItemActive   @profiles_40
      @setItemInactive @profiles_20
      @setItemInactive @profiles_60
      @setItemInactive @profiles_80

    $(@profiles_60).on 'click', =>
      @setItemActive   @profiles_60
      @setItemInactive @profiles_40
      @setItemInactive @profiles_20
      @setItemInactive @profiles_80

    $(@profiles_80).on 'click', =>
      @setItemActive   @profiles_80
      @setItemInactive @profiles_40
      @setItemInactive @profiles_60
      @setItemInactive @profiles_20

    $(@reset_all_filters).on 'click', => @advanced_filter.resetAllFilters()
  ###
  request : => Q.spawn =>
    @tutorsCache ?= {}
    return unless @changed
    return if @sending
    hash = Feel.urlData.state.url
    if @tutorsCache?[hash]?
      return yield @filter hash
    @sending = true
    @changed = false
    tutors = yield @$send './tutors','quiet'
    storage = $.localStorage.get 'tutors'
    storage ?= {}
    tutors  ?= []
    for val in tutors
      val.receive = new Date().getTime()
      storage[val.account] = val
    for key,val of storage
      unless val.receive
        delete storage[key]
      if (new Date().getTime()-val.receive)>1000*60*5
        delete storage[key]
    $.localStorage.set 'tutors',storage
    @tutors = storage
    @tutorsCache[hash] = true
    @sending = false
    yield @filter(hash)
    if @changed
      setTimeout @request,3000
  ###
  ###
  filter : (hash)=> do Q.async =>
    @lastFilter ?= ""
    if hash?
      return if @lastFilter == hash
    @lastFilter = hash
    @filtering ?= 0
    return if @filtering > 1
    if @filtering == 1
      @filtering = 2
      return
    @filtering = 1
    tutors = yield @js.filter @tutors, (yield Feel.urlData.get())?.mainFilter
    #@tutors_result.empty()
    otutor = {}
    for tutor in tutors
      otutor[tutor.account] = tutor
    onow = {}
    for tutor in @now
      onow[tutor.data.account] = tutor
    spl = []
    for i in [0...@now.length]
      tutor = @now[i]
      unless otutor[tutor.data.account]?
        tutor.dom.remove()
        spl.push i
        delete onow[tutor.data.account]
        i--
    min = 0
    for s in spl
      @now.splice s-min,1
      min++

    nnow = []
    for tutor,i in tutors
      if onow[tutor.account]?
        nnow.push onow[tutor.account]
        if JSON.stringify(onow[tutor.account].data)!=JSON.stringify(tutor)
          onow[tutor.account].data = tutor
          onow[tutor.account].nt.setValue tutor
        continue
      nt = @tree.tutor_test.class.$clone()
      nt.setValue tutor
      nnow.push {
        data : tutor
        dom  : $('<div class="tutor_result"></div>').append nt.dom
        nt   : nt
      }
    yield Q()
    cnum = 0
    for t,i in nnow
      break if i>=(@tnum)
      if cnum > 5
        yield Q()
        cnum = 0
      if i == 0
        unless @tutors_result.find(':first')[0]==t.dom[0]
          cnum++
          @tutors_result.prepend t.dom
      else
        unless nnow[i-1].dom.next()[0]==t.dom[0]
          cnum++
          nnow[i-1].dom.after t.dom
      if (i+1)>=(@tnum)
        ll = @tutors_result.find(':last')
        dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height())
        if dist >= 0
          @tnum+=5
    @now = nnow
    if @filtering == 2
      @filtering = 0
      return yield @filter()
    @filtering = 0
  ###
  check_place_click :(e) =>
    if (!@popup.is(e.target) && @popup.has(e.target).length == 0)
      Feel.go '/second_step'

  getValue : =>
    return {
      sort : @sort.getValue()
    }


  setItemActive: (div)=>
    return if div.hasClass 'active'
    div.addClass 'active'
    return 0

  setItemInactive: (div)=>
    return if !div.hasClass 'active'
    div.removeClass 'active'
    return 0


