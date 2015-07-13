class @main extends EE
  Dom : =>
    #@tutor_status        = @found.tutor_status
    @tutor_status_top    = @found.tutor_status_top
    @tutor_status_bottom = @found.tutor_status_bottom
    #@place               = @found.place
    @place_top           = @found.place_top
    @place_bottom        = @found.place_bottom
    #@price               = @found.price
    @price_top           = @found.price_top
    @price_bottom        = @found.price_bottom
    if @tree.list_subject?
      @subject = @tree.list_subject.class
    if @tree.tutor_status?
      @tutor_status = @tree.tutor_status.class
    if @tree.at_home_button? && @tree.in_tutoring_button? && @tree.remotely_button?
      @at_home_button = @tree.at_home_button.class
      @in_tutoring_button = @tree.in_tutoring_button.class
      @remotely_button = @tree.remotely_button.class
    if @tree.address_input?
      @address_input = @tree.address_input.class
    if @tree.price_slider_top?
      @lesson_price = @tree.price_slider_top.class
    @out_err = @found.out_err
    @tag  = @found.tag
    @tags = @found.tags
    @issue_bid_button = @tree.issue_bid_button.class
  setValue : (value={})=>
    for key,val of value
      @tree.value[key] = val
    value = @tree.value
    @tutor_status_top?.find('.title').text value?.tutor_status_text
  getValue : => @tree.value
    
  show: =>
    @popupAdd @tutor_status_top,@tutor_status_bottom,@found.tutor_status
    @popupAdd @place_top,@place_bottom,@found.place
    @popupAdd @price_top,@price_bottom,@found.price
    #@issue_bid_button.submit()
    #$(@tutor_status_top).on 'click',  => $(@tutor_status_bottom).toggle()
    #$(@place_top).on 'click',         => $(@place_bottom).toggle()
    #$(@price_top).on 'click',         => $(@price_bottom).toggle()
    @found.submit.on 'click', (e)=>
      e.preventDefault()
      Feel.go @found.submit.attr 'href'
    ###
      if (!div.is(e.target) && div.has(e.target).length == 0)
         $(@tutor_status_bottom).hide()

    ###
    # TODO: click on out of element
  popupAdd : (top,bottom,main)=>
    top.on 'click', =>
      bottom.toggle()
      if bottom.is ':visible'
        Feel.popupAdd main,bottom

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

  getData : =>
    ret = {}
    if @subject? then ret.subject = @subject.getValue()
    if @tutor_status? then ret.tutor_status = @tutor_status.getValue()
    if @at_home_button? && @in_tutoring_button? && @remotely_button?
      place = []
      if @at_home_button.getValue() then place.push 'pupil'
      if @in_tutoring_button.getValue() then place.push 'tutor'
      if @remotely_button.getValue() then place.push 'other'
      ret.place = place
    #if @address_input?
      #d
    if @lesson_price?
      price = []
      price_val = @lesson_price.getValue()
      price.push price_val.left
      price.push price_val.right
      ret.lesson_price = price
    return ret

  check_form : => return true
    #r1 = @checkItem @subject, 'пожалуйста, введите корректный предмет'
    #r2 = @checkItem @tutor_status, 'пожалуйста, выберите статус преподавателя'
    #if r1 && r2
      #return true
    #else
      #return false

  checkItem :(div, error_text)=>
    if div?
      if div.getValue().length < 2
        div.setErrorDiv @out_err
        div.showError error_text
        return false
    return true
