class @main
  show : =>
    @hint = @dom.find ".hint"
    @hint_button = @hint.find(".button")
    @hint_button.on 'click', => @hide @hint


  hide: (element)=>
    element.css("display", "none")

    





