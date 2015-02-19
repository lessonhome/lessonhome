class @main
  show : =>
    @man    = @tree.sex_man.class
    @woman  = @tree.sex_woman.class

    @man  .on 'active', => @woman .disable()
    @woman.on 'active', => @man   .disable()

    @hint = @dom.find ".hint"
    @hint_button = @hint.find(".button")
    @hint_button.on 'click', => @hide @hint


  hide: (element)=>
    element.css("display", "none")

    
