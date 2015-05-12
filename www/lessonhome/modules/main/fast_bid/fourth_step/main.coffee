
class @main
  Dom : =>
    # status
    @student   = @tree.student.class
    @teacher   = @tree.teacher.class
    @professor = @tree.professor.class
    @native    = @tree.native.class
    #
    @experience  = @tree.experience.class
    @age_slider  = @tree.age_slider.class
    @gender_data = @tree.gender_data.class

  save : => Q().then =>
    if @check_form()
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
    errs = @js.check @getData()
    for e in errs
      @parseError e
    return errs.length==0

  parseError : (errs)=>
    return true

  getData : =>
    status = []
    if @student.getValue()   then status.push 'Студент'
    if @teacher.getValue()   then status.push 'Преподаватель школы'
    if @professor.getValue() then status.push 'Преподаватель ВУЗа'
    if @native.getValue()    then status.push 'Носитель языка'
    return {
      status     : status
      experience : @experience.getValue()
      age_slider : @age_slider.getValue()
      sex        : @gender_data.getValue()
    }
