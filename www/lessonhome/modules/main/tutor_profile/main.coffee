
class @main
  Dom: =>
    @back = @found.back
  show: =>
    $(@back).click => @goBack()
  goBack: =>
    document.location.href = window.history.back()