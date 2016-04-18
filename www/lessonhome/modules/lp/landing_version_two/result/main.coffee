class @main
  Dom : =>
  show: =>
    @found.attach_pos?.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'null', 'motivation'
