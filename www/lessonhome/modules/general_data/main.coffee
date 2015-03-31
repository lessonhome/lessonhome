

class @main
  Dom : =>
    @out_err = @found.out_err
    @day_err = @found.day_err
    @month_err = @found.month_err
    @year_err = @found.year_err

  show : =>
    @first_name = @tree.first_name.class
    @first_name.input.on 'focusout',@check_form

    @last_name = @tree.last_name.class
    @last_name.input.on 'focusout',@check_form

    @patronymic = @tree.patronymic.class
    @patronymic.input.on 'focusout',@check_form

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
    if !@day.suitability()
      errs.push 'bad_day'
    if !@month.suitability()
      errs.push 'bad_month'
    if !@year.suitability()
      errs.push 'bad_year'
    errs = @js.check errs, @getData()
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
      first_name  : @first_name.getValue()
      last_name   : @last_name.getValue()
      patronymic  : @patronymic.getValue()
      day         : @day.getValue()
      month       : @month.getValue()
      year        : @year.getValue()
    }

  parseError : (err)=>
    switch err
      when "short_first_name"
        @first_name.outErr "Слишком короткое имя"
      when "short_last_name"
        @last_name.outErr "Слишком короткая фамилия"
      when "short_patronymic"
        @patronymic.outErr "Слишком короткое отчество"
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


