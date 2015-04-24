class @main
  Dom : =>
    @out_err_experience     = @found.out_err_experience
    @add_button             = @found.add_button
    @clone_el               = @found.clone_el
    @place_of_work          = @found.place_of_work
    @post                   = @found.post

  show : =>
    @work = []
    for key,val of @tree.work
      @work.push
        place : val.place_of_work.class
        post  : val.post.class
    # drop_down_list
    @experience = @tree.experience_tutoring.class
    @extra_info = @tree.extra_info.class

    # drop_down_list catch focus
    #@experience.on  'focus',  => @clearOutErr @out_err_experience,  @experience


    # add more work place
    @add_button.on 'click', => @cloneInput()




  cloneInput : =>
    el = @clone_el.clone()
    el.find('input').val('')
    el.appendTo('.block_work')

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
    extra_info  : @extra_info.getValue()
    experience  : @experience.getValue()
    work        : for w in @work
      place : w.place.getValue()
      post  : w.post.getValue()

  parseError : (err,index)=>
    if typeof err == 'object'
      for key,val of err
        @parseError key, val
      return
    switch err
    #short
      when "short_place"
        @work[index].place.showError "Слишком короткое место"
      when "short_post"
        @work[index].post.showError "Слишком короткая должность"
    #empty
      when "empty_place"
        @work[index].place.showError "Введите место"
      when "empty_post"
        @work[index].post.showError "Введите должность"
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