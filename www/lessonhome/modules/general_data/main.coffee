

class @main
  Dom : =>
    @out_err = @found.out_err
    @day_err = @found.day_err
    @month_err = @found.month_err
    @year_err = @found.year_err
    @out_err_day    = @found.out_err_day
    @out_err_status = @found.out_err_status

  show : =>
    @first_name = @tree.first_name.class
    @first_name.on 'blur',@check_form

    @last_name = @tree.last_name.class
    @last_name.on 'blur',@check_form

    @middle_name = @tree.middle_name.class
    @middle_name.on 'blur',@check_form

    @sex = @tree.gender_data.class

    @day = @tree.birth_data.day.class
    
    @month = @tree.birth_data.month.class

    @year = @tree.birth_data.year.class
    @status = @tree.status.class

    #TODO: move it's code in drop_down_list.coffee
    @day.input.on 'focus',    => @clearOutErr @out_err_day
    @month.input.on 'focus',  => @clearOutErr @out_err_day
    @year.input.on 'focus',   => @clearOutErr @out_err_day
    @status.input.on 'focus', => @clearOutErr @out_err_status

    @status = @tree.status.class

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          console.log true
          return true
        if errs?.length
          @parseError errs
        return false
    else
      return false

  check_form : =>
    errs = @js.check @getData()
    if !@day.exists()
      errs.push 'bad_day'
    if !@month.exists()
      errs.push 'bad_month'
    if !@year.exists()
      errs.push 'bad_year'
    if !@status.exists()
      errs.push 'bad_status'
    
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
      status      : @status.getValue()
    }

  parseError : (err)=>
    switch err
      when "short_first_name"
        @first_name.showError "Слишком короткое имя"
      when "short_last_name"
        @last_name.showError "Слишком короткая фамилия"
      when "short_middle_name"
        @middle_name.showError "Слишком короткое отчество"
      when "empty_first_name"
        @first_name.showError "Заполните имя"
      when "empty_last_name"
        @last_name.showError "Заполните фамилию"
      when "empty_middle_name"
        @middle_name.showError "Заполните отчество"
      when "empty_date"
        @outErr "Заполните дату", @out_err_day
      when "empty_status"
        @outErr "Выберите статус", @out_err_status
      when "bad_day"
        @outErr "Введите корректный день", @out_err_day
      when "bad_month"
        @outErr "Введите корректный месяц", @out_err_day
      when "bad_year"
        @outErr "Введите корректный год", @out_err_day
      when "bad_status"
        @outErr "Выберите статус из списка", @out_err_status


  outErr : (err, el) =>
    el.text err
    setTimeout =>
      el.show()
    , 100

  clearOutErr : (el) =>
    el.addClass 'hide'
    el.text('')


