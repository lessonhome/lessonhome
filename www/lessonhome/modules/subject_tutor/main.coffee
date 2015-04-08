
class @main


  show: =>
    # drop_down_list
    @subject            = @tree.subject.class
    @list_course        = @tree.list_course.class
    @place              = @tree.price.class
    @students_in_group  = @tree.students_in_group.class
    #input
    @price                = @tree.price.class
    @group_lessons_price  = @tree.group_lessons_price.class
    # checkboxes
    @pre_school    = @tree.pre_school.class
    @junior_school = @tree.junior_school.class
    @medium_school = @tree.medium_school.class
    @high_school   = @tree.high_school.class
    @student       = @tree.student.class
    @adult         = @tree.adult.class



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
    if !@subject.exists() && @subject.getValue() != 0
      errs.push 'bad_subject'
    if !@list_course.exists() && @list_course.getValue() != 0
      errs.push 'bad_list_course'
    if !@place.exists() && @place.getValue() != 0
      errs.push 'bad_subject'
    if !@students_in_group.exists() && @students_in_group.getValue() != 0
      errs.push 'bad_students_in_group'
    if !@subject.exists() && @subject.getValue() != 0
      errs.push 'bad_subject'
    if !@subject.exists() && @subject.getValue() != 0
      errs.push 'bad_subject'



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
      subject             : @subject.getValue()
      list_course         : @list_course.getValue()
      place               : @place.getValue()
      students_in_group   : @students_in_group.getValue()
      price               : @price.getValue()
      group_lessons_price : @group_lessons_price.getValue()
      pre_school          : @pre_school   .state
      junior_school       : @junior_school.state
      medium_school       : @medium_school.state
      high_school         : @high_school  .state
      student             : @student      .state
      adult               : @adult        .state
    }
