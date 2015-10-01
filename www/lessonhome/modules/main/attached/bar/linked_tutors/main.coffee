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
    for index, prep of preps
      el = yield @tree.tutor.$clone()
      el.setValue prep
      el.found.rem.on 'click', =>
        el.found.rem.off 'click'
        delete @linked[index]
  createDom : (prep) =>
