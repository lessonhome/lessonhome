

class @main
  Dom : =>
    @out_err_date     = @found.out_err_date
    @out_err_status   = @found.out_err_status

  show : =>
    @first_name   = @tree.first_name.class
    @last_name    = @tree.last_name.class
    @middle_name  = @tree.middle_name.class
    @sex          = @tree.gender_data.class
    console.log @sex 
    @day          = @tree.birth_data.day.class
    @month        = @tree.birth_data.month.class
    @year         = @tree.birth_data.year.class
    @status       = @tree.status.class
    #TODO: try @gender one be active else false
    #@gender       = @tree.gender.class

    #TODO: move it's code in drop_down_list.coffee
    @day.input.on     'focus',  => @clearOutErr @out_err_date, @day
    @month.input.on   'focus',  => @clearOutErr @out_err_date, @month
    @year.input.on    'focus',  => @clearOutErr @out_err_date, @year
    @status.input.on  'focus',  => @clearOutErr @out_err_status, @status

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs,err})=>
        if err?
          errs?=[]
          errs.push err
        if status=='success'
          return true
        if errs?.length
          for e in errs
            @parseError e
        return false
    else
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
        @outErr "Заполните дату", @out_err_date, [@day, @month, @year]
      when "empty_status"
        @outErr "Выберите статус", @out_err_status, @status
      #correct
      when "bad_day"
        @outErr "Введите корректный день", @out_err_date, @day
      when "bad_month"
        @outErr "Введите корректный месяц", @out_err_date, @month
      when "bad_year"
        @outErr "Введите корректный год", @out_err_date, @year
      when "bad_status"
        @outErr "Выберите статус из списка", @out_err_status, @status
      when "unselect sex"
        #@outErr "Выберите пол", @out_err_sex, @sex
        alert 'sex'
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


