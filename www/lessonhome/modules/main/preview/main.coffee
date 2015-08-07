
class @main extends EE
  constructor : ->
  Dom : => do Q.async =>
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
    #@tutors = $.localStorage.get 'tutors'
    #@tutors ?= {}
    @loaded = {}
    
    @tnum   = 10
    @tfrom  = 0
    @now    = []
    @changed = true
    @sending = false
    yield @filter()
    yield Feel.urlData.request()
    yield @filter()

  reshow : => do Q.async =>
    @_reshow ?= 0
    @_reshow = 2 if @_reshow == 1
    return _waitFor @,'reshow' if @_reshow > 1
    @_reshow = 1

    @domnowi = 0
    @domnow  = null

    hash = yield Feel.urlData.filterHash()
    @loaded[hash] ?= {}
    @loaded[hash].count ?= 0
    @loaded[hash].from  ?= 0
    @loaded[hash].tutors ?= []
    @loaded[hash].reloaded ?= false
    unless @loaded[hash].reloaded
      @loaded[hash].reloading = Feel.BTutors.request {count:@tnum,from:@tfrom}
    if (@loaded[hash].from > @tfrom) || ((@loaded[hash].from+@loaded[hash].count)<(@tfrom+@tnum))
      @loaded[hash].tutors = yield @filter2()
    yield @show2 @loaded[hash]
    
    unless @loaded[hash].reloaded
      yield @loaded[hash].reloading
      @loaded[hash].reloaded = true
      @loaded[hash].tutors = yield @filter2()
      yield @show2 @loaded[hash]

    if @_reshow == 2
      @_reshow = 0
      return @reshow()
    @_reshow = 0

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
  show : =>
    @advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll',=>
      ll = @tutors_result.find(':last')
      dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
      if dist >= 0
        @filter().done()
    @on 'change', => Q.spawn =>
      if (new Date().getTime() - @loadedTime)>(1000*5)
        Feel.sendActionOnce 'tutors_filter',1000*60*2
      @changed = true
      #@tnum = 4
      yield @filterChange()
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
  request : => Q.spawn =>
    @tutorsCache ?= {}
    return unless @changed
    return if @sending
    hash = Feel.urlData.state.url
    if @tutorsCache?[hash]?
      return yield @filter hash
    @sending = true
    @changed = false
    console.log 'loading tutors'
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
    console.log 'filtering'
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


