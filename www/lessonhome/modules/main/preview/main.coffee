
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
    if indexes.length is 0
      @message_empty.fadeIn 400
    else
      @message_empty.fadeOut 400
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
    return if indexes.length<=@count
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
    @relinkedOne cl
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
      @found['t'+n].parent().click => Q.spawn =>
        o = {}
        switch true
          when /price/.test name
            o[name] = {
              left : 500
              right : 3500
            }
          when /place/.test name
            o.place = mf.place
            key = name.replace 'place_', ''
            o.place[key] = false
            o.place['area_'+key] = []
            if key == 'tutor'
              o.time_spend_way = 120
          when /^status/.test name
            o.tutor_status = mf.tutor_status
            key = name.replace 'status_', ''
            o.tutor_status[key] = false
          when /experience/.test name
            o.experience = mf.experience
            key = name.replace 'experience_', ''
            o.experience[key] = false
          when /group/.test name
            o.group_lessons = 'не важно'
          when /pupil_status/.test name
            o.pupil_status = 'не важно'
          when /with/.test name
            o[name] = false
          else
            o[name]=val
        yield Feel.urlData.set('mainFilter',o)
      @found['t'+n].text(t)
      @found['t'+n].parent().show()

    mf = yield Feel.urlData.get 'mainFilter'


    #========================= Subject, course

    if mf.subject.length
      set_ 'subject',mf.subject.join ', '
      subject = true
    else
      subject = false
      set_ 'subject'
    if mf.course.length
      set_ 'course',mf.course.join ', '
      course = true
    else
      course = false
      set_ 'course'
    if mf.pupil_status &&  (mf.pupil_status!='не важно')
      set_ 'pupil_status',mf.pupil_status,'pupil_status','не важно'
      pupil_status = true
    else
      pupil_status = false
      set_ 'pupil_status'

    #========================= Price

    if mf.price.left == mf.price.right
      price = true
      set_ 'price', "#{mf.price.left}р.  в час"
    else if mf.price.left > 500 && mf.price.right < 3500
      price = true
      set_ 'price', "От #{mf.price.left}р. до #{mf.price.right}р. в час"
    else if mf.price.left > 500
      price = true
      set_ 'price', "От #{mf.price.left}р. в час"
    else if mf.price.right < 3500
      price = true
      set_ 'price', "До #{mf.price.right}р. в час"
    else
      price = false
      set_ 'price'

    #=========================== Place
    areas = (@dom.find '.area')
    pupil = areas[0]
    tutor = areas[1]
    timeBox = tutor.nextSibling

    if mf.place.pupil
      place = true
      pupil.className = pupil.className.replace('hidden', '')
      places = ''
      if mf.place.area_pupil?.length
        places = ': '
        for place in mf.place.area_pupil
          places += place+'; '
      set_ 'place_pupil', 'У себя'+places

    else
      pupil.className += 'hidden' unless pupil.className.match 'hidden'
      set_ 'place_pupil'
    if mf.place.tutor
      place = true
      tutor.className = pupil.className.replace('hidden', '')
      places = '; '
      if mf.place.area_tutor?.length
        places = ': '
        for place in mf.place.area_tutor
          places += place+'; '
      timeBox.style.display = 'inline-block'
      time = ''
      if mf.time_spend_way? != 120
        time = "до #{mf.time_spend_way} мин."
      set_ 'place_tutor', 'У репетитора'+places+time
    else
      tutor .className += 'hidden' unless tutor.className.match 'hidden'
      timeBox.style.display = 'none'
      set_ 'place_tutor'
    if mf.place.remote
      place = true
      set_ 'place_remote', 'Удалённо'
    else
      set_ 'place_remote'

    #============================= Status

    tutor_status = false

    if mf.tutor_status.student
      tutor_status = true
      set_ 'status_student', 'Студент'
    else
      set_ 'status_student'
    if mf.tutor_status.school_teacher
      tutor_status = true
      set_ 'status_school_teacher', 'Преподаватель школы'
    else
      set_ 'status_school_teacher'
    if mf.tutor_status.university_teacher
      tutor_status = true
      set_ 'status_university_teacher', 'Преподаватель ВУЗа'
    else
      set_ 'status_university_teacher'
    if mf.tutor_status.private_teacher
      tutor_status = true
      set_ 'status_private_teacher', 'Частный преподаватель'
    else
      set_ 'status_private_teacher'
    if mf.tutor_status.native_speaker
      tutor_status = true
      set_ 'status_native_speaker', 'Носитель языка'
    else
      set_ 'status_native_speaker'

    #========================= Experience

    exp = false

    if mf.experience.little_experience
      exp = true
      set_ 'experience_little_experience', 'Опыт: 1-2 года'
    else
      set_ 'experience_little_experience'
    if mf.experience.big_experience
      exp = true
      set_ 'experience_big_experience', 'Опыт: 3-4 года'
    else
      set_ 'experience_big_experience'
    if mf.experience.bigger_experience
      exp = true
      set_ 'experience_bigger_experience', 'Опыт: более 4 лет'
    else
      set_ 'experience_bigger_experience'

    #======================== Group lessons

    group = true

    if mf.group_lessons.match '2'
      set_ 'group_lessons', 'Групповые занятия: 2-4 ученика'
    else if mf.group_lessons.match '8'
      set_ 'group_lessons', 'Групповые занятия: до 8 учеников'
    else if mf.group_lessons.match '10'
      set_ 'group_lessons', 'Групповые занятия: от 10 учеников'
    else
      set_ 'group_lessons'
      group = false


    #======================== Gender

    gender = true

    if mf.gender == 'male'
      set_ 'gender', 'Пол: мужской'
    else if mf.gender == 'female'
      set_ 'gender', 'Пол: женский'
    else
      set_ 'gender'
      gender = false

    #======================= Reviews

    if mf.with_reviews
      set_ 'with_reviews', 'Только с отзывами'
    else
      set_ 'with_reviews'

    #======================= Verification

    if mf.with_verification
      set_ 'with_verification', 'Только проверенные'
    else
      set_ 'with_verification'

    #======================= Photos

    if mf.with_photo
      set_ 'with_photo', 'Только с фото'
    else
      set_ 'with_photo'


    if subject || course || pupil_status
      @advanced_filter.activate 'subject',true
    else
      @advanced_filter.activate 'subject',false

    if price
      @advanced_filter.activate 'price', true
    else
      @advanced_filter.activate 'price', false

    if place
      @advanced_filter.activate 'place', true
    else
      @advanced_filter.activate 'place', false

    if tutor_status
      @advanced_filter.activate 'tutor_status', true
    else
      @advanced_filter.activate 'tutor_status', false

    if exp
      @advanced_filter.activate 'experience', true
    else
      @advanced_filter.activate 'experience', false

    if gender
      @advanced_filter.activate 'gender', true
    else
      @advanced_filter.activate 'gender', false

    if group
      @advanced_filter.activate 'group_lessons', true
    else
     @advanced_filter.activate 'group_lessons', false

  updatePlaces : (from ,to) => Q.spawn =>
    mf = yield Feel.urlData.get 'mainFilter'

    places = []

    if mf.place[from]
      for place in mf.place['area_'+from]
        if mf.place['area_'+to].indexOf(place) == -1
          places.push place

    if places.length
      o = {}
      o.place = mf.place
      o.place['area_'+to] = o.place['area_'+to].concat places
      yield Feel.urlData.set('mainFilter',o)
  onscroll : => Q.spawn =>
    ll = @tutors_result.find(':last')
    dist = ($(window).scrollTop()+$(window).height())-(ll?.offset?()?.top+ll?.height?())
    if dist >= -400
      yield @addTen()
  show : =>
    @tree.advanced_filter.tutor.class.on 'change', => @updatePlaces('pupil', 'tutor')
    @tree.advanced_filter.pupil.class.on 'change', => @updatePlaces('tutor', 'pupil')
    @advanced_filter.on 'change',=> @emit 'change'
    $(window).on 'scroll.tutors',@onscroll
    @on 'change', =>
      if (new Date().getTime() - @loadedTime)>(1000*5)
        Feel.sendActionOnce 'tutors_filter',1000*60*2
    Feel.urlData.on 'change', => Q.spawn =>
      console.log 'change'
      yield @apply_filter()
    @tree.advanced_filter.apply.class.on 'submit',=> Q.spawn =>
      top = $('#m-main-advanced_filter').offset?()?.top
      $(window).scrollTop top-10 if top >= 0
      yield @apply_filter true
      

    @choose_tutors_num = @found.choose_tutors_num
    @sort.on 'change',  => @emit 'change'


    @background_block.on 'click',  @check_place_click

    $(@profiles_20).on 'click',   =>
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
  check_place_click :(e) =>
    if (!@popup.is(e.target) && @popup.has(e.target).length == 0)
      Feel.go '/second_step'
  apply_filter : (force=false)=> do Q.async =>
    @linked = yield Feel.urlData.get 'mainFilter','linked'
    yield @setFiltered()
    @hashnow ?= 'null'
    hashnow = yield Feel.urlData.filterHash()
    return if (@hashnow == hashnow) && !force
    @hashnow = hashnow
    @changed = true
    yield @reshow()

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

  relinkedOne: (cl) => cl.tree?.tutor_extract?.class?.setLinked @linked
  relinkedAll: => for index, el of @doms then @relinkedOne el.class

