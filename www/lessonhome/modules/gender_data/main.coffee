class @main extends EE
  show: =>
    @man    = @tree.sex_man.class
    @woman  = @tree.sex_woman.class
    @state  = @tree.value
    console.log @state

    switch @state
      when "male"
        @man.click()
      when "female"
        @woman.click()

    @man  .on 'active', =>
      @woman .disable()
      @state = "male"
    @woman.on 'active', =>
      @state = "female"
      @man   .disable()
