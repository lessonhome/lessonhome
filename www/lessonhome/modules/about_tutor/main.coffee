
class @main
  show: =>
    @reason = @tree.reason.class
    @interests = @tree.interests.class
    @slogan = @tree.slogan.class
    @about = @tree.about.class

  getData : =>
    return {
      reason:    @reason.getValue()
      interests: @interests.getValue()
      slogan:    @slogan.getValue()
      about:     @about.getValue()
    }

  save : => do Q.async =>
    if @check_form()
      {status,errs} = yield @$send('./save',@getData())
      return true if status=='success'
      return false
    else
      return false

  check_form : =>
    errs = []
    #errs = @js.check errs, @getData()
    #for e in errs
      #@parseError e
    return errs.length==0






























