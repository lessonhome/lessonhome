class @main
  show: =>
    @checkbox = @tree.hour.class.found.check_box
    @checkbox.click => console.log @checkbox.is('.active')