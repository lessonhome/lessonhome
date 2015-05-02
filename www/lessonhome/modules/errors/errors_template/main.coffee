
class @main
  show: =>
    @back_link = @dom.find('a.back')
    @back_link.click => @goBack()
  goBack: =>
    document.location.href = window.history.back()