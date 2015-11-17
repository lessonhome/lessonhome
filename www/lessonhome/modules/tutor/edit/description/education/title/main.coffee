class @main
  Dom : =>
    @university= @found.university
    @faculty = @found.faculty

    @observer = null
  show : =>
#    @setInstitution 'МОрПРОМТОРГ'
#    @setFaculty 'Электроники и вычислительной техники'
    @university.on 'click', => @notifyObserver 'cl_uni'
    @faculty.on 'click', => @notifyObserver 'cl_fac'

  setObserver : (observer) => @observer = observer
  notifyObserver : (message) => @observer?.handleEvent? @, message



  setUniversity : (value) =>
    if value? and value isnt ''
      @university.removeClass('empty').text value
    else
      @university.addClass('empty').text 'Вуз'

  setFaculty : (value) =>
    if value? and value isnt ''
      @faculty.removeClass('empty').text value
    else
      @faculty.addClass('empty').text 'Факультет'

  setValue : (value = {}) =>
    @setUniversity value.institution
    @setFaculty value.faculty