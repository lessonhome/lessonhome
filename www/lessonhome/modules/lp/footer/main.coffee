class @main
  Dom : =>
    @requestCall  = @found.request_a_call
  show: =>
    @requestCall.leanModal()
    @found.attach.on 'click', -> Feel.root.tree.class.attached.showForm()