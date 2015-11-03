class @main
  Dom : =>
    @requestCall = @found.request_a_call
  show: =>
    @requestCall.leanModal()