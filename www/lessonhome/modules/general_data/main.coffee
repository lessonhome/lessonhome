

class @main
  Dom : =>
    @out_err = @found.out_err
    @day_err = @found.day_err
    @month_err = @found.month_err
    @year_err = @found.year_err

  show : =>
    @first_name = @tree.first_name.class
    @first_name.on 'blur',@check_form

    @last_name = @tree.last_name.class
    @last_name.on 'blur',@check_form

    @middle_name = @tree.middle_name.class
    @middle_name.on 'blur',@check_form

    @sex = @tree.gender_data.class

    @day = @tree.birth_data.day.class
    @day.input.on 'focusout',@check_form
    @day.input.on 'focus',@clearOutErrDate

    @month = @tree.birth_data.month.class
    @month.input.on 'focusout',@check_form
    @month.input.on 'focus',@clearOutErrDate

    @year = @tree.birth_data.year.class
    @year.input.on 'focusout',@check_form
    @year.input.on 'focus',@clearOutErrDate


  save : => Q().then =>
    if @check_form()
      console.log @getData()
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
    errs = []
    if !@day.exists()
      errs.push 'bad_day'
    if !@month.exists()
      errs.push 'bad_month'
    if !@year.exists()
      errs.push 'bad_year'
    errs = @js.check errs, @getData()
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
      first_name  : @first_name.getValue()
      last_name   : @last_name.getValue()
      middle_name : @middle_name.getValue()
      sex         : @sex.state
      day         : @day.getValue()
      month       : @month.getValue()
      year        : @year.getValue()
    }


  parseError : (err)=>
    switch err
      when "short_first_name"
        @first_name.showError "Слишком короткое имя"
      when "short_last_name"
        @last_name.showError "Слишком короткая фамилия"
      when "short_middle_name"
        @patronymic.showError "Слишком короткое отчество"
      when "empty_date"
        @outErrDate "Заполните дату"
      when "bad_day"
        @outErrDate "Введите корректный день"
      when "bad_month"
        @outErrDate "Введите корректный месяц"
      when "bad_year"
        @outErrDate "Введите корректный год"

  outErrDate : (err) =>
    @out_err.show()
    @out_err.text err


  clearOutErrDate : (err) =>
    @out_err.hide()
    @out_err.text('')


























