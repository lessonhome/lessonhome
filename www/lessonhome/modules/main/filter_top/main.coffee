class @main extends EE
  Dom : =>
    @button_back   = @tree.button_back.class
    @button_issue  = @tree.button_issue.class
    @button_onward = @tree.button_onward.class
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


  show: =>
    @choose_block = @dom.find('.choose_block')
    @i = 2

    ### выходит ошибка на ч-ой странице, subject_tag не определена TODO ###
    #@subject_tag = @tree.choose_subject.class
    @empty_subject_tag = @tree.empty_choose_subject
    #@newSubjectTag()

    @button_issue.on 'submit', =>
      @save().then (data)=>
        if data
          @bIssue()

    @button_onward.on 'submit', =>
      @save().then (data)=>
        if data
          @bNext()

    @button_back  .on 'submit', =>
      @save()
      @bBack()


  newSubjectTag: =>
    new_tag = @empty_subject_tag
    new_tag.id = @i++
    new_tag.text = 'new'
    @choose_block.append('<div class="choose_button">' + new_tag + '</div>')

  bNext : =>
    @button_onward.submit()

  bBack : =>
    @button_back.submit()

  bIssue : =>
    @button_issue.submit()

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
