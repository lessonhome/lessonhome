
class @main
  show: =>
    @subject = @tree.subject.class
    @course  = @tree.list_course.class

    # checkboxes

    @pre_school    = @tree.pre_school.class
    @junior_school = @tree.junior_school.class
    @medium_school = @tree.medium_school.class
    @high_school   = @tree.high_school.class
    @student       = @tree.student.class
    @adult         = @tree.adult.class

  getData : =>
    return {
      subject : ''
      pre_school    : @pre_school   .state
      junior_school : @junior_school.state
      medium_school : @medium_school.state
      high_school   : @high_school  .state
      student       : @student      .state
      adult         : @adult        .state
    }
###
  save : => Q().then =>
    if @check_form()
      console.log @getData()
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

###
