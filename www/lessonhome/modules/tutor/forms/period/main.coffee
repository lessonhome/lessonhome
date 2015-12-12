class @main
  Dom : =>
    @from = @tree.from.class
    @till = @tree.till.class
  show : =>
    now = (new Date).getFullYear()
    @from.setItems [now-80..now-1]
    @till.setItems [now-68..now+11]

    @from.on 'change', @updateTill
  getValue: => [@from.getValue() , @till.getValue()]
  setValue: (data) =>
    @from.setValue data[0]
    @till.setValue data[1]
  updateTill : =>
    from = parseInt @from.getValue()
    @till.setItems(values = [from+1..from+12])
    till = parseInt @till.getValue()

    return for y in values when till == y
    @till.setValue ''+values[0]

  setErrorDiv: (div) =>
    @from.setErrorDiv div

  showError : (message) =>
    @from.showError(message)
    @till.showError()

  hideError : =>
    @from.hideError()
    @till.hideError()