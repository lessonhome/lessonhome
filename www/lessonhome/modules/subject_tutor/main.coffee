
class @main
  Dom: =>
    @out_err_subject = @found.out_err_subject
  show: =>

    # drop_down_list
    @subject       = @tree.subject.class

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return false
        #if errs?.length
         # @parseError errs
        return false
    else
      return false
  check_form : =>
    errs = @js.check @getData()
    if !@subject.exists() && @subject.getValue() != 0
      errs.push 'bad_subject'
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
      subject: @subject.getValue()
    }

  parseError : (err)=>
    switch err
      when "empty_subject"
        @subject.setErrorDiv @out_err_subject
        @subject.showError "Выберите предмет"
      when "bad_subject"
        @subject.setErrorDiv @out_err_subject
        @subject.showError "Выберите корректный предмет"