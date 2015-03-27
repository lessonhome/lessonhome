



class @main
  Dom : =>
  show : =>
    @first_name = @tree.first_name.class

  save : => Q().then =>
    if @check_form()
      console.log @getData()
      return @$send('saveFormTutorProfileFirstStep',@getData())
      .then ({status,err})=>
        if status=='success'
          return true
        else
          return false
    else
      return false
  check_form : =>
    ret = @js.check 'first_name',@first_name.getValue()
    if ret?.err?
      alert ret.err
      return false
    return true
  getData : =>
    first_name : @first_name.getValue()
