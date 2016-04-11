class @main
  Dom : =>
    Q.spawn =>
      yield Feel.jobs.onSignal 'bottomBarHide',@onBarHide
      yield Feel.jobs.onSignal 'bottomBarShow',@onBarShow
  show: =>
    @found.attach.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'callback', 'motivation'
  onBarHide : =>
    @dom.css 'padding-bottom', ''
  onBarShow : =>
    @dom.css 'padding-bottom', '70px'
