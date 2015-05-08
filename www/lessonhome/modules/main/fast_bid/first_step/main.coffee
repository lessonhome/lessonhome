
class @main
  Dom : =>
    @name      = @tree.name.class
    @phone     = @tree.phone.class
    @call_time = @tree.call_time.class
    @email     = @tree.email.class
    @subject   = @tree.subject.class
    @out_err_subject = @found.out_err_subject
    @comments  = @tree.comments.class

  show : =>
    # error div
    @subject.setErrorDiv @out_err_subject
  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return true
        if errs?.length
          @parseError errs
        return false
    else
      return false

  check_form : =>
    errs = @js.check @getData()
    if !@phone.doMatch() then errs.push "bad_phone"
    if !@subject.exists()
      errs.push 'bad_subject'
    for e in errs
      @parseError e
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
      when "short_name"
        @name.showError "Слишком короткое имя "
      when "short_phone"
        @phone.showError "Неккорректный телефон"
    #empty
      when "empty_name"
        @name.showError "Введите имя"
      when "empty_phone"
        @phone.showError "Введите телефон"
      when "empty_subject"
        @subject.showError "Выберите предмет"
    #correct
      when "bad_subject"
        @subject.showError "Некорректный предмет"



