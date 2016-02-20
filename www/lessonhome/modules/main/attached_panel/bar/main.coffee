class @main
  constructor: ->
    $W @
    @saveLinked = undefined
  Dom : =>
    @preps = @found.preps
    @panel = @found.bottom_panel
    @btn_attach = @found.open_attach
    @linked = {}
    @show_tutors = @found.show_select_rep
    @show_tutors_count = 0
  show : =>
    Q.spawn => Feel.jobs.onSignal? "bidSuccessSend", @clean
    @btn_attach.click => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'add_tutors'
    @found.clean.on 'click', @clean
    @show_tutors.on 'click', =>

      if @show_tutors_count == 0
        @preps.slideDown(300)
        @show_tutors_count = 1
      else
        @preps.slideUp(300)
        @show_tutors_count = 0

  clean : =>
    do Q.async =>
      yield Feel.urlData.set 'mainFilter','linked', {}
    return false
  reshow : (linked) =>
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    return if @saveLinked == JSON.stringify linked
    @saveLinked = JSON.stringify linked
    if @reshowing > 0
      @reshowing = 2
      return Object.keys(linked ? {}).length
    @reshowing = 1
    @linked = linked
    linked = for index of linked then index
    @preps.empty()
    if linked.length isnt 0
      preps = yield Feel.dataM.getTutor linked
      preps = for i in linked then preps[i]
      for prep in preps
        @preps.append yield @createDom prep
      #@slickInit()
    @found.count.text "#{linked.length}"
    if @reshowing == 2
      @reshowing = 0
      return @reshow()
    @reshowing = 0
    return linked.length

  createDom : (prep) =>
    el = yield @tree.tutor.class.$clone()
    el.setValue prep
    el.found.rem.on 'click', =>
      do Q.async =>
        el.found.rem.off 'click'
        delete @linked[prep.index]
        yield Feel.urlData.set 'mainFilter','linked', @linked
      return false
    return $('<div class="block">').append el.dom
  setValue : (data) =>
    console.log 'weerd', data

  slickInit : =>
    @preps.slick({
      dots: false,
      infinite: true,
      slidesToShow: 8,
      slidesToScroll: 4,
      responsive: [
        {
          breakpoint: 1000,
          settings: {
            infinite: true,
            slidesToShow: 2,
            slidesToScroll: 2
          }
        },
        {
          breakpoint: 480,
          settings: {
            infinite: true,
            slidesToShow: 1,
            slidesToScroll: 1
          }
        }
      ]
    })

