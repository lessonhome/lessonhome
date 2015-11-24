class @main
  Dom : =>

    @country  = @tree.country.class
    @city = @tree.city.class
    @faculty = @tree.faculty.class
    @chair = @tree.chair.class
    @qualification = @tree.qualification.class
    @comment = @tree.comment.class
    @period_education = @tree.period_education.class

    @fill = false

  show : =>
    @country.setErrorDiv        @found.out_err_country
    @city.setErrorDiv           @found.out_err_city
    @faculty.setErrorDiv        @found.out_err_faculty
    @chair.setErrorDiv          @found.out_err_chair
    @qualification.setErrorDiv  @found.out_err_qualification
    @period_education.setErrorDiv @found.out_err_period

  getValue : =>
    period = @period_education.getValue()
    @fill = false
    country : @inspect @country.getValue()
    city : @inspect @city.getValue()
    faculty : @inspect @faculty.getValue()
    chair : @inspect @chair.getValue()
    qualification : @inspect @qualification.getValue()
    period :
      start : @inspect period[0]
      end : @inspect period[1]
    comment : @inspect @comment.getValue()

  inspect : (val) =>
    if not @fill and val isnt '' then @fill = true
    return val

  setValue : (data = {}) =>
    @country.setValue data.country 
    @city.setValue data.city
    @faculty.setValue data.faculty 
    @chair.setValue data.chair 
    @qualification.setValue data.qualification 
    @comment.setValue data.comment
    @period_education.setValue [data.period?.start, data.period?.end]

  hideError : => @showErrors {}

  showErrors : (errors) =>
    if errors['period']?
      @period_education.showError(errors['period'])
    else
      @period_education.hideError()
