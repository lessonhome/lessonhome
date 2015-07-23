
class @main
  Dom : =>
    #@pupil_status = @tree.pupil_status.class
    #@course = @tree.course.class
    #@knowledge_level = @tree.knowledge_level.class
    #@price_slider_bids = @tree.price_slider_bids.class
    #@goal = @tree.goal.class

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
    return {
      #pupil_status : @pupil_status.getValue()
      #course : @course.getValue()
      #knowledge_level : @knowledge_level.getValue()
      #price_slider_bids : @price_slider_bids.getValue()
      #goal : @goal.getValue()
    }

  parseError : (errs)=>
    return true

