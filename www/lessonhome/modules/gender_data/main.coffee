class @main extends EE
  Dom: =>
    @out_err_sex      = @found.out_err_sex
  show: =>
    @man    = @tree.sex_man.class
    @woman  = @tree.sex_woman.class
    @state  = @tree.value

    switch @getValue()
      when "male"
        @setValue "male"
      when "female"
        @setValue "female"
      when 'fm'
        @setValue 'fm'
      else @setValue ''

    @man  .on 'inactive', =>
      @state = false
      @emit 'change'

    @woman.on 'inactive', =>
      @state = false
      @emit 'change'
      @emit 'end'


    @man  .on 'active', =>
      @woman .disable()
      @state = "male"
      @emit 'select'
      @emit 'change'
      @emit 'end'


    @woman.on 'active', =>
      @state = "female"
      @man   .disable()
      @emit 'select'
      @emit 'change'
      @emit 'end'



  setValue : (val)=>
    val ?= @tree.default
    switch val
      when "male"
        @man.setActive()
        @state = "male"
      when 'female'
        @woman.setActive()
        @state = "female"
      when 'fm'
        @man.setActive()
        @woman.setActive()
        @state = "fm"
      else
        @man  .disable()
        @woman.disable()
        @state = ''
    @emit 'change'

  getValue : => @state

  showError : (error)=>
    @out_err_sex.text error
    @out_err_sex.show()
  hideError : =>
    @out_err_sex.hide()
    @out_err_sex.text ""

  reset : =>
    @setValue @tree.default ? ''
