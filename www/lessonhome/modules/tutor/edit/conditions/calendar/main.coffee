
class @main
  save : => do Q.async =>
    {status,errs} = yield @$send('./save',@getData())
    if status=='success'
      return true
    return false
  getData: => calendar: @tree.calendar.class.getValue()






