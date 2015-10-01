class @main
  constructor: ->
    Wrap @
  Dom : =>
    @count = @found.count
    @btn_clean = @found.clean
    @preps = @found.preps
    @linked = {}
  show : =>
    yield @reshow()
    Feel.urlData.on 'change', @reshow.out
  reshow : =>
    @linked = yield Feel.urlData.get 'mainFilter','linked'
    linked = for index of @linked then index
    @count.text "(#{linked.length})"
    console.log linked
    preps = yield Feel.dataM.getTutor linked
    preps = for i in linked then preps[i]
    console.log preps
    @preps.empty()
    for index of @linked
      console.log index
      el = yield @tree.tutor.class.$clone()
      el.setValue preps[index]
      el.found.rem.on 'click', =>
        do Q.async =>
          el.found.rem.off 'click'
          delete @linked[index]
          yield Feel.urlData.set 'mainFilter','linked', @linked
        return false
      console.log el
      @preps.append el.dom
#  createDom : (prep) =>
