
class @main extends EE
  constructor : ->
  Dom : => do Q.async =>
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
    @tutors = $.localStorage.get 'tutors'
    @tutors ?= {}
    @tnum = 1
    @now    = []
    @changed = true
    @sending = false
    yield @filter()
    @request()
  show : =>
    @advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll',=>
      ll = @tutors_result.find(':last')
      dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
      if dist >= 0
        @filter().done()
    @on 'change', =>
      @changed = true
      @filter().done()
      @request()
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
    return unless @changed
    return if @sending
    @sending = true
    @changed = false
    tutors = yield @$send './tutors','quiet'
    storage = $.localStorage.get 'tutors'
    storage ?= {}
    tutors  ?= []
    for val in tutors
      storage[val.account] = val
    $.localStorage.set 'tutors',storage
    @tutors = storage
    @sending = false
    yield @filter()
    if @changed
      setTimeout @request,3000
    
  filter : => do Q.async =>
    tutors = @js.filter @tutors, (yield Feel.urlData.get())?.mainFilter
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
    for t,i in nnow
      break if i>=(@tnum)
      if i == 0
        unless @tutors_result.find(':first')[0]==t.dom[0]
          @tutors_result.prepend t.dom
      else
        unless nnow[i-1].dom.next()[0]==t.dom[0]
          nnow[i-1].dom.after t.dom
      if (i+1)>=(@tnum)
        ll = @tutors_result.find(':last')
        dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height())
        if dist >= 0
          @tnum++

    @now = nnow

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


