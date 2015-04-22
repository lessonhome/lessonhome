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
      else

    @man  .on 'inactive', =>
      @state = false

    @woman.on 'inactive', =>
      @state = false

    @man  .on 'active', =>
      @woman .disable()
      @state = "male"
      @emit 'select'

    @woman.on 'active', =>
      @state = "female"
      @man   .disable()
      @emit 'select'


  setValue : (val)=>
    if val == "male"
      @man.setActive()
      @state = "male"
    if val == 'female'
      @woman.setActive()
      @state = "female"


  getValue : => @state

  showError : (error)=>
    @out_err_sex.text error
    @out_err_sex.show()
  hideError : =>
    console.log 'hhhh'
    @out_err_sex.hide()
    @out_err_sex.text ""