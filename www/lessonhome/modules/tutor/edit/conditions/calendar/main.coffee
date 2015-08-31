
class @main
  save : => Q().then =>
    console.log 'edit/conditions/calendar'
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return true
        #if errs?.length
        #@parseError errs
        return false
    else
      return false

  getData: =>
    return {
      calendar: @tree.calendar.class.getValue()
    }

  check_form : => true






