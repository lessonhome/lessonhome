class @main
  constructor: ->
    Wrap @
  Dom : =>
    @count = @found.count
    @btn_clean = @found.clean
    @preps = @found.preps
    @panel = @found.bottom_panel
    @carousel = @found.jcarousel
    @linked = {}
  show : =>
#    yield @reshow()
#    Feel.urlData.on 'change', @reshow.out
    @carousel.jcarousel()
    @btn_clean.on 'click', =>
      do Q.async =>
        yield Feel.urlData.set 'mainFilter','linked', {}
      return false
  reshow : (linked) =>
    linked ?= yield Feel.urlData.get 'mainFilter','linked'
    @linked = linked
    linked = for index of @linked then index
    @preps.empty()
    if linked.length isnt 0
      preps = yield Feel.dataM.getTutor linked
      preps = for i in linked then preps[i]
      for prep in preps
        @preps.append yield @createDom prep
    @carousel.jcarousel 'reload'
    @count.text "(#{linked.length})"
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