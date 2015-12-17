class @main
  constructor: ->
    $W @
    @saveLinked = undefined
  Dom : =>
    @preps = @found.preps
    @panel = @found.bottom_panel
    @btn_attach = @found.btn_attach
    @linked = {}
  show : =>
    @found.clean.on 'click', =>
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
    linked = for index of @linked then index
    @preps.empty()
    if linked.length isnt 0
      preps = yield Feel.dataM.getTutor linked
      preps = for i in linked then preps[i]
      for prep in preps
        @preps.append yield @createDom prep
    @found.count.text "(#{linked.length})"
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
    return $('<li class="block">').append el.dom
  setValue : (data) =>
