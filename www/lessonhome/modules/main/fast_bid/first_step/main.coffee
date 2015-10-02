
class @main
  Dom : =>
    @name      = @tree.name.class
    @phone     = @tree.phone.class
    @email     = @tree.email.class
    @call_time = @tree.call_time.class
    @subject   = @tree.subject.class
    @comments  = @tree.comments.class
    @out_err_subject = @found.out_err_subject


  show : =>
    #if @tree.name?.value?
    @emit 'make_active_issue_bid_button'

    # change
    ###
    @name.on 'blur', =>
      if @checkIssueBidActive()
        @emit 'make_active_issue_bid_button'
      else
        @emit 'make_inactive_issue_bid_button'

    @phone.on 'blur', =>
      if @checkIssueBidActive()
        @emit 'make_active_issue_bid_button'
      else
        @emit 'make_inactive_issue_bid_button'

    @subject.on 'end', =>
      if @checkIssueBidActive()
        @emit 'make_active_issue_bid_button'
      else
        @emit 'make_inactive_issue_bid_button'
    ###
    # error div
    @subject.setErrorDiv @out_err_subject

  save : => do Q.async =>
    if @check_form()
      data = yield Feel.urlData.get 'pupil'
      data.linked = yield Feel.urlData.get 'mainFilter','linked'
      {status,errs} = yield @$send('../third_step/save',data)
      if status == 'success'
        Feel.sendActionOnce 'fast_bids_first_step'
        return true
      if errs?.length
        @parseError errs
      return false
      #return @$send('./save',@getData())
      #.then ({status,errs})=>
      #  if status=='success'
      #    return true
      #  if errs?.length
      #    @parseError errs
      #  return false
    else
      return false

  check_form : =>
    errs = @js.check @getData()
    if !@phone.doMatch() then errs.push "bad_phone"
    #if !@subject.exists()
    #  errs.push 'bad_subject'
    for e in errs
      @parseError e
    return errs.length==0

  checkIssueBidActive : =>
    errs = @js.check @getData()
    if !@phone.doMatch() then errs.push "bad_phone"
    #if !@subject.exists()
    #  errs.push 'bad_subject'
    return errs.length==0



  getData : =>
    return {
      name:      @name.getValue()
      phone:     @phone.getValue()
      call_time: @call_time.getValue()
      email:     @email.getValue()
      subject:   @subject.getValue()
      comments:  @comments.getValue()
    }

  parseError : (err)=>
    switch err
    #short
      #when "short_name"
      #  @name.showError "Слишком короткое имя "
      when "short_phone"
        @phone.showError "Неккорректный телефон"
    #empty
      #when "empty_name"
      #  @name.showError "Введите имя"
      when "empty_phone"
        @phone.showError "Введите телефон"
      #when "empty_subject"
      #  @subject.showError "Выберите предмет"
    #correct
      #when "bad_subject"
      #  @subject.showError "Некорректный предмет"



