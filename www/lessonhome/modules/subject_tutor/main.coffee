
class @main
  Dom: =>

  show: =>
    # drop_down_list
    @subject       = @tree.subject.class
    @course        = @tree.course.class
    #@place              = @tree.price.class
    #@students_in_group  = @tree.students_in_group.class

    # checkboxes categories
    @pre_school    = @tree.pre_school.class
    @junior_school = @tree.junior_school.class
    @medium_school = @tree.medium_school.class
    @high_school   = @tree.high_school.class
    @student       = @tree.student.class
    @adult         = @tree.adult.class

    #

    @duration = @tree.duration.class
    @price_from = @tree.price_slider.start.class
    @price_till = @tree.price_slider.end.class

    @place_tutor  = @tree.place_tutor.class
    @place_pupil  = @tree.place_pupil.class
    @place_remote = @tree.place_remote.class
    @place_cafe   = @tree.place_cafe.class

    @comments = @tree.comments.class

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return false
        #if errs?.length
         # @parseError errs
        return false
    else
      return false
  check_form : =>
    errs = []
    ###
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

    for e in errs
      @parseError e
    ###
    #return errs.length==0
    return true


  getData : =>
    return {
      name: @subject.getValue()
      list_course: @list_course.getValue()
      description: @comments.getValue()
      pre_school: @pre_school.state
      junior_school: @junior_school.state
      medium_school: @medium_school.state
      high_school: @high_school.state
      student: @student.state
      adult: @adult.state
      duration: @duration.getValue()
      price_from: @price_from.getValue()
      price_till: @price_till.getValue()
      place_tutor: @place_tutor.state
      place_pupil: @place_pupil.state
      place_remote: @place_remote.state
      place_cafe: @place_cafe.state
      ###
      subject             : @subject.getValue()
      list_course         : @list_course.getValue()
      pre_school          : @pre_school   .state
      junior_school       : @junior_school.state
      medium_school       : @medium_school.state
      high_school         : @high_school  .state
      student             : @student      .state
      adult               : @adult        .state
      # price_place_time if check_box active input mast be wright
      tutor_ch45        : @tutor_ch45.state
      tutor_ch60        : @tutor_ch60.state
      tutor_ch90        : @tutor_ch90.state
      tutor_ch120       : @tutor_ch120.state
      price_tutor45     : @price_tutor45.getValue()
      price_tutor60     : @price_tutor60.getValue()
      price_tutor90     : @price_tutor90.getValue()
      price_tutor120    : @price_tutor120.getValue()

      pupil_ch45        : @pupil_ch45.state
      pupil_ch60        : @pupil_ch60.state
      pupil_ch90        : @pupil_ch90.state
      pupil_ch120       : @pupil_ch120.state
      price_pupil45     : @price_pupil45.getValue()
      price_pupil60     : @price_pupil60.getValue()
      price_pupil90     : @price_pupil90.getValue()
      price_pupil120    : @price_pupil120.getValue()

      remote_ch45       : @remote_ch45.state
      remote_ch60       : @remote_ch60.state
      remote_ch90       : @remote_ch90.state
      remote_ch120      : @remote_ch120.state
      price_remote45    : @price_remote45.getValue()
      price_remote60    : @price_remote60.getValue()
      price_remote90    : @price_remote90.getValue()
      price_remote120   : @price_remote120.getValue()

      group_ch45        : @group_ch45.state
      group_ch60        : @group_ch60.state
      group_ch90        : @group_ch90.state
      group_ch120       : @group_ch120.state
      price_group45     : @price_group45.getValue()
      price_group60     : @price_group60.getValue()
      price_group90     : @price_group90.getValue()
      price_group120    : @price_group120.getValue()
      ###
    }
