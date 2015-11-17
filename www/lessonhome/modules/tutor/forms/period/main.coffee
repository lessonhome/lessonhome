class @main
  Dom : =>
    @from = @tree.from.class
    @till = @tree.till.class
  show : =>
    now = (new Date).getFullYear()
    @from.setItems [now-90..now-1]
    @from.on 'change', =>
      f = parseInt @from.getValue()
      @till.setValue ''
      @till.setItems [f+1..f+12]
  getValue: => [@from.getValue(), @till.getValue()]
  setValue: (data) =>
    @from.setValue data[0]
    @till.setValue data[1]