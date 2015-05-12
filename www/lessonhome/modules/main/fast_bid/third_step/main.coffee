
class @main
  Dom: =>
    @tutor             = @tree.tutor.class
    @student           = @tree.student.class
    @web               = @tree.web.class
    @your_address      = @tree.your_address.class
    @time_spend_way    = @tree.time_spend_way.class
    @calendar          = @tree.calendar.class
    @time_spend_lesson = @tree.time_spend_lesson.class

  show : =>

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

  getData : =>
    #console.log @time_spend_way.getValue()
    place = []
    if @tutor.getValue()   then place.push 'tutor'
    if @student.getValue() then place.push 'pupil'
    if @web.getValue()     then place.push 'other'

    lesson_duration = []
    ld_val = @time_spend_lesson.getValue()
    lesson_duration.push ld_val.left
    lesson_duration.push ld_val.right

    return {
      place: place
      your_address: @your_address.getValue()
      time_spend_way: @time_spend_way.getValue().left
      calendar: @calendar.getValue()
      lesson_duration: lesson_duration
    }

  parseError : (errs)=>
    return true
