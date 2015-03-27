

class @main
  Dom : =>
  show : =>
    @first_name = @tree.first_name.class
    @first_name.input.on 'focusout',@check_form
    @last_name = @tree.last_name.class
    @last_name.input.on 'focusout',@check_form
    @patronymic = @tree.patronymic.class
    @patronymic.input.on 'focusout',@check_form




  save : => Q().then =>
    if @check_form()
      console.log @getData()
      return @$send('saveFormTutorProfileFirstStep',@getData())
      .then ({status,err})=>
        if status=='success'
          return true
        else
          return false
    else
      return false

  check_form : =>
    ret = @js.check @getData()
    if ret?.err?
      @parseError ret.err
      return false
    return true
  getData : =>
    first_name  : @first_name.getValue()
    last_name   : @last_name.getValue()
    patronymic  : @patronymic.getValue()
  parseError : (err)=>
    switch err
      when "short_first_name"
        @first_name.outErr "Слишком короткое имя"
      when "short_last_name"
        @last_name.outErr "Слишком короткая фамилия"
      when "short_patronymic"
        @patronymic.outErr "Слишком короткое отчество"
