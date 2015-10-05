class @main
  constructor: ->
    Wrap @
  Dom : =>
    @count = @found.count
    @btn_clean = @found.clean
    @carousel = @found.jcarousel
    @preps = @found.preps
    @panel = @found.bottom_panel
    @left = @found.left
    @right = @found.right
    @linked = {}
  show : =>

#    yield @reshow()
#    Feel.urlData.on 'change', @reshow.out
#    @carousel.jcarousel {
#        itams : 'li.block'
#      }

    @btn_clean.on 'click', =>
      do Q.async =>
        yield Feel.urlData.set 'mainFilter','linked', {}
      return false

#    @left.jcarouselControl {carousel: @carousel, target : '-=2'}
#    .on 'jcarouselcontrol:inactive', => @left.addClass 'inactive'
#    .on 'jcarouselcontrol:active', => @left.removeClass 'inactive'
#    @right.jcarouselControl {carousel: @carousel, target : '+=2'}
#    .on 'jcarouselcontrol:inactive', => @right.addClass 'inactive'
#    .on 'jcarouselcontrol:active', => @right.removeClass 'inactive'
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
  setValue : (data) =>
    console.log 'weerd', data