class @main
  constructor : ->
    $W @
  Dom : =>
    @out_err_experience     = @found.out_err_experience

  show : =>
    @work = []
    @work.push @tree.work.class
    @clone = @tree.work.class
    @found.add_button.click => @add()
    works = yield  @$send './save','quiet'
    @clone.on 'change',=> @emit 'wchange'
    for work,i in works
      continue if i == 0
      @add work
    # drop_down_list
    @experience = @tree.experience_tutoring.class
    @extra_info = @tree.extra_info.class

    # drop_down_list catch focus
    @experience.on  'focus',  => @experience.hideError()

    # error div
    @experience.setErrorDiv @out_err_experience
    @on 'wchange',=> Q.spawn => @save true
  add : (data={})=>
    cl = @clone.$clone()
    dom = $('<div class="item"></div>')
    dom.append cl.dom
    cl.setValue data
    @found.block_work.append dom
    @work.push cl
    cl.on 'change',=> @emit 'wchange'
  save : (quiet=false)=>
    if quiet
      return yield @$send('./save',@getData(quiet),true,'quiet')
    if @check_form()
      return @onReceive yield @$send('./save',@getData())
    else
      return false
  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    if errs?.length
      for e in errs
        @parseError e
    return false
  check_form : =>
    return true
    errs = @js.check @getData()
    if !@experience.exists() && @experience.getValue().length!=0
      errs.push 'bad_experience'
    for e in errs
      @parseError e
    return errs.length==0

  getData : (quiet=false)=>
    work = []
    for w in @work
      continue if w.removed
      o = w.getValue()
      s = ""
      for key,val of o
        s+=val
      if s.length < 2
        w.remove() unless quiet
        continue
      work.push o
    return {
      work : work
      extra_info  : @extra_info.getValue()
      experience  : @experience.getValue()
    }
      
  parseError : (err,index)=>
    if typeof err == 'object'
      for key,val of err
        @parseError key, val
      return
    switch err
    #short
      when "short_place"
        @work[index].place.showError "Слишком короткое место"
      when "short_post"
        @work[index].post.showError "Слишком короткая должность"
    #empty
      when "empty_place"
        @work[index].place.showError "Введите место"
      when "empty_post"
        @work[index].post.showError "Введите должность"
      when "empty_exp"
        @experience.showError "Выберите опыт"
      #correct
      when "bad_experience"
        @experience.showError "Выберите корректный опыт"
