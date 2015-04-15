class @main
  Dom : =>
    @out_err_experience     = @found.out_err_experience


  show : =>
    # input
    @place      = @tree.place_of_work.class
    @post       = @tree.post.class
    # drop_down_list
    @experience = @tree.experience_tutoring.class

    # drop_down_list catch focus
    @experience.on  'focus',  => @clearOutErr @out_err_experience,  @experience



  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then @onReceive
    else
      return false
  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    if errs?.length
      for e in errs
        @parseError e
    return false
  check_form : =>
    errs = @js.check @getData()
    if !@experience.exists() && @experience.getValue().length!=0
      errs.push 'bad_experience'
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
      place             : @place.getValue()
      post              : @post.getValue()
      experience        : @experience.getValue()
    }

  parseError : (err)=>
    switch err
    #short
      when "short_place"
        @place.showError "Слишком короткое место"
      when "short_post"
        @post.showError "Слишком короткая должность"
    #empty
      when "empty_place"
        @place.showError "Введите место"
      when "empty_post"
        @post.showError "Введите должность"
      when "empty_exp"
        @outErr "Выберите опыт", @out_err_experience, @experience
      else
        alert 'die'



  outErr : (err, err_el, el) =>
    if el instanceof Array
      for _el in el
        _el.err_effect()
    else
      el.err_effect()
    err_el.text err
    setTimeout =>
      err_el.show()
    , 100

  clearOutErr : (err_el ,el) =>
    el.clean_err_effect()
    err_el.hide()
    err_el.text('')