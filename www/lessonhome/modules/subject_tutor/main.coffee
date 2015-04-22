
class @main
  Dom: =>

  show: =>

    # drop_down_list
    @subject       = @tree.subject.class


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
    errs = @js.check @getData()
    if !@subject.exists() && @subject.getValue() != 0
      errs.push 'bad_subject'
    for e in errs
      @parseError e
    return errs.length==0
    return true


  getData : =>
    return {
      subject: @subject.getValue()
    }