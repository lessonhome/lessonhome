class @main
  Dom : =>

    @country  = @tree.country.class
    @city = @tree.city.class
    @faculty = @tree.faculty.class
    @chair = @tree.chair.class
    @qualification = @tree.qualification.class
    @comment = @tree.comment.class
    @period_education = @tree.period_education.class

  show : =>
    @country.setErrorDiv        @found.out_err_country
    @city.setErrorDiv           @found.out_err_city
    @faculty.setErrorDiv        @found.out_err_faculty
    @chair.setErrorDiv          @found.out_err_chair
    @qualification.setErrorDiv  @found.out_err_qualification
    @period_education.setErrorDiv @found.out_err_period

  getValue : =>
    period = @period_education.getValue()

    country : @country.getValue()
    city : @city.getValue()
    faculty : @faculty.getValue()
    chair : @chair.getValue()
    qualification : @qualification.getValue()
    period :
      start : period[0]
      end : period[1]
    comment : @comment.getValue()

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
