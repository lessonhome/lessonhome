class @main
  Dom : =>
    @requestCall  = @found.request_a_call
    Q.spawn =>
      yield Feel.jobs.onSignal 'bottomBarHide',@onBarHide
      yield Feel.jobs.onSignal 'bottomBarShow',@onBarShow
  show: =>
    @requestCall.leanModal()
  onBarHide : =>
    @dom.css 'padding-bottom', ''
  onBarShow : =>
    @dom.css 'padding-bottom', '70px'
