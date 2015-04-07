
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

  save : => Q().then =>
    if @check_form()
      console.log @getData()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          console.log true
          return true
      #if errs?.length
        #@parseError errs
      return false
    else
      return false

  check_form : =>
    errs = []
    #errs = @js.check errs, @getData()
    #for e in errs
      #@parseError e
    return errs.length==0






































