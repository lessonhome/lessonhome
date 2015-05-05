class @main
  Dom : =>
    @out_err_country        = @found.out_err_country
    @out_err_city           = @found.out_err_city
    @out_err_university     = @found.out_err_university
    @out_err_faculty        = @found.out_err_faculty
    @out_err_chair          = @found.out_err_chair
    @out_err_qualification  = @found.out_err_qualification
    @out_err_period         = @found.out_err_period

  show : =>
    # drop_down_list
    @country        = @tree.country.class
    @city           = @tree.city.class
    @university     = @tree.university.class
    @faculty        = @tree.faculty.class
    @chair          = @tree.chair.class
    @qualification  = @tree.qualification.class
    @learn_from     = @tree.learn_from.class
    @learn_till     = @tree.learn_till.class


    # clear error
    @country.on       'focus',  => @country.hideError()
    @city.on          'focus',  => @city.hideError()
    @university.on    'focus',  => @university.hideError()
    @faculty.on       'focus',  => @faculty.hideError()
    @chair.on         'focus',  => @chair.hideError()
    @qualification.on 'focus',  => @qualification.hideError()
    @learn_from.on    'focus',  => @learn_from.hideError()
    @learn_till.on    'focus',  => @learn_till.hideError()

    # error div
    @country.setErrorDiv        @out_err_country
    @city.setErrorDiv           @out_err_city
    @university.setErrorDiv     @out_err_university
    @faculty.setErrorDiv        @out_err_faculty
    @chair.setErrorDiv          @out_err_chair
    @qualification.setErrorDiv  @out_err_qualification
    @learn_from.setErrorDiv     @out_err_period
    @learn_till.setErrorDiv     @out_err_period



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
    if !@qualification.exists() && @qualification.getValue().length!=0
      errs.push 'bad_qualification'
    if !@learn_from.exists() && @learn_from.getValue().length!=0
      errs.push 'bad_learn_from'
    if !@learn_till.exists() && @learn_till.getValue().length!=0
      errs.push 'bad_learn_till'
    ###
    for e in errs
      @parseError e
    return errs.length==0

  getData : =>
    return {
    country         : @country.getValue()
    city            : @city.getValue()
    university      : @university.getValue()
    faculty         : @faculty.getValue()
    chair           : @chair.getValue()
    qualification   : @qualification.getValue()
    learn_from      : @learn_from.getValue()
    learn_till      : @learn_till.getValue()
    }

  parseError : (err)=>
    switch err
    #empty
      when "empty_country"
        @country.showError "Заполните страну"
      when "empty_city"
        showError "Заполните город"
      when "empty_university"
        showError "Заполните университет"
      when "empty_faculty"
        showError "Заполните факультет"
      when "empty_chair"
        showError "Заполните кафедру"

      when "empty_qualification"
        showError "Выберите статус"
      #correct
      when "bad_country"
        @country.showError "Выберите страну из списка"
      when "bad_city"
        @city.showError "Выберите город из списка"
      when "bad_university"
        @university.showError "Выберите ВУЗ из списка"
      when "bad_faculty"
        @faculty.showError "Выберите факультет из списка"
      when "bad_chair"
        @chair.showError "Выберите кафедру из списка"
      when "bad_qualification"
        @qualification.showError "Выберите статус из списка"
      else
        alert 'die'
