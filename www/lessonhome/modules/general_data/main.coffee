

class @main
  Dom : =>
    @out_err_date     = @found.out_err_date
    @out_err_status   = @found.out_err_status

  show : =>
    # input
    @first_name   = @tree.first_name.class
    @last_name    = @tree.last_name.class
    @middle_name  = @tree.middle_name.class
    # button
    @sex          = @tree.gender_data.class
    # drop_down_list
    @day          = @tree.birth_data.day.class
    @month        = @tree.birth_data.month.class
    @year         = @tree.birth_data.year.class
    @status       = @tree.status.class

    # clear error
    @day.on     'focus',  => @day.hideError()
    @month.on   'focus',  => @month.hideError()
    @year.on    'focus',  => @year.hideError()
    @status.on  'focus',  => @status.hideError()
    @sex.on     'select', => @sex.hideError()

    # error div
    @day.setErrorDiv    @out_err_date
    @month.setErrorDiv  @out_err_date
    @year.setErrorDiv   @out_err_date
    @status.setErrorDiv @out_err_status


  save : => do Q.async =>
    if @check_form()
      return @onReceive yield  @$send('./save',@getData())
    else
      return false
  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    @showError errs
    return false

  check_form : =>
    errs = @js.check @getData()
    if !@day.exists() && @month.exists() && @year.exists()
      errs.push 'bad_day'
    if !@month.exists() && @day.exists() && @year.exists()
      errs.push 'bad_month'
    if !@year.exists() && @month.exists() && @day.exists()
      errs.push 'bad_year'
    if !@year.exists() && !@month.exists() && @day.exists()
      errs.push 'empty_date'
    if !@year.exists() && @month.exists() && !@day.exists()
      errs.push 'empty_date'
    if @year.exists() && !@month.exists() && !@day.exists()
      errs.push 'empty_date'
    if !@status.exists() && @status.getValue().length!=0
      errs.push 'bad_status'
    @showError errs
    return errs.length==0

  getData : =>
    return {
      first_name  : @first_name.getValue()
      last_name   : @last_name.getValue()
      middle_name : @middle_name.getValue()
      sex         : @sex.getValue()
      day         : @day.getValue()
      month       : @month.getValue()
      year        : @year.getValue()
      status      : @status.getValue()
    }

  showError : (errs) =>
    errs = [errs] if typeof(errs) is 'string'

    if errs?.length
      Feel.sendAction 'error_on_page'
      for e in errs
        @parseError e

  parseError : (err)=>
    switch err
      #short
      when "short_first_name"
        @first_name.showError "Слишком короткое имя"
      when "short_last_name"
        @last_name.showError "Слишком короткая фамилия"
      when "short_middle_name"
        @middle_name.showError "Слишком короткое отчество"
      #empty
      when "empty_first_name"
        @first_name.showError "Заполните имя"
      when "empty_last_name"
        @last_name.showError "Заполните фамилию"
      when "empty_middle_name"
        @middle_name.showError "Заполните отчество"
      when "empty_date"
        errArr = [@day, @month, @year]
        for val in errArr
          if !val.exists()
            val.showError "Заполните дату"
      when "empty_status"
        @status.showError "Выберите статус"
      #correct
      when "bad_day"
        @day.showError "Введите корректный день"
      when "bad_month"
        @month.showError "Введите корректный месяц"
      when "bad_year"
        @year.showError "Введите корректный год"
      when "bad_status"
        @status.showError "Выберите статус из списка"
      when "unselect_sex"
        @sex.showError "Выберите пол"



