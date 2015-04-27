class @main
  Dom : =>
    @out_err_country      = @found.out_err_country
    @out_err_city         = @found.out_err_city
    @out_err_university   = @found.out_err_university
    @out_err_faculty      = @found.out_err_faculty
    @out_err_chair        = @found.out_err_chair
    @out_err_status       = @found.out_err_status
    @out_err_date         = @found.out_err_date

  show : =>
    @country      = @tree.country.class
    @city         = @tree.city.class
    @university   = @tree.university.class
    @faculty      = @tree.faculty.class
    @chair        = @tree.chair.class
    @status       = @tree.status.class
    @day          = @tree.release_date.day.class
    @month        = @tree.release_date.month.class
    @year         = @tree.release_date.year.class


    @country.on     'focus',  => @clearOutErr @out_err_date,  @country
    @city.on        'focus',  => @clearOutErr @out_err_date,  @city
    @university.on  'focus',  => @clearOutErr @out_err_date,  @university
    @faculty.on     'focus',  => @clearOutErr @out_err_date,  @faculty
    @chair.on       'focus',  => @clearOutErr @out_err_date,  @chair
    @status.on      'focus',  => @clearOutErr @out_err_date,  @status
    @day.on         'focus',  => @clearOutErr @out_err_date,  @day
    @month.on       'focus',  => @clearOutErr @out_err_date,  @month
    @year.on        'focus',  => @clearOutErr @out_err_date,  @year


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
    ###
    if !@country.exists() && @country.getValue().length!=0
      errs.push 'bad_country'
    if !@city.exists() && @city.getValue().length!=0
      errs.push 'bad_city'
    if !@university.exists() && @university.getValue().length!=0
      errs.push 'bad_university'
    if !@faculty.exists() && @faculty.getValue().length!=0
      errs.push 'bad_faculty'
    if !@chair.exists() && @chair.getValue().length!=0
      errs.push 'bad_chair'
    if !@status.exists() && @status.getValue().length!=0
      errs.push 'bad_status'
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
    ###
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
    country     : @country.getValue()
    city        : @city.getValue()
    university  : @university.getValue()
    faculty     : @faculty.getValue()
    chair       : @chair.getValue()
    status      : @status.getValue()
    day         : @day.getValue()
    month       : @month.getValue()
    year        : @year.getValue()
    }

  parseError : (err)=>
    switch err
    #empty
      when "empty_country"
        @outErr "Заполните страну", @out_err_country, @country
      when "empty_city"
        @outErr "Заполните город",@out_err_city, @city
      when "empty_university"
        @outErr "Заполните университет",@out_err_university, @university
      when "empty_faculty"
        @outErr "Заполните факультет",@out_err_faculty, @faculty
      when "empty_chair"
        @outErr "Заполните факультет",@out_err_chair, @chair
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
      when "bad_country"
        @outErr "Выберите страну из списка", @out_err_country, @country
      when "bad_city"
        @outErr "Выберите город из списка", @out_err_city, @city
      when "bad_university"
        @outErr "Выберите ВУЗ из списка", @out_err_university, @university
      when "bad_faculty"
        @outErr "Выберите факультет из списка", @out_err_faculty, @faculty
      when "bad_chair"
        @outErr "Выберите кафедру из списка", @out_err_chair, @chair
      when "bad_status"
        @outErr "Выберите статус из списка", @out_err_status, @status

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