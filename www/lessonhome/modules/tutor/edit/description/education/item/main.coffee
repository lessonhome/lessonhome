class @main
  Dom : =>
    @out_err_country        = @found.out_err_country
    @out_err_city           = @found.out_err_city
    @out_err_university     = @found.out_err_university
    @out_err_faculty        = @found.out_err_faculty
    @out_err_chair          = @found.out_err_chair
    @out_err_qualification  = @found.out_err_qualification
    @out_err_period         = @found.out_err_period
    ##
    @restore = @found.restore_block
    @active = @found.active_block
    @container = @found.container

  remove : =>
    @dom.parent().remove()
    @removed = true

  show : =>
#    @found.remove_button.click @remove

    # drop_down_list
    @country        = @tree.country.class
    @city           = @tree.city.class
    @university     = @tree.university.class
    @faculty        = @tree.faculty.class
    @chair          = @tree.chair.class
    @qualification  = @tree.qualification.class
    @learn_from     = @tree.learn_from.class
    @learn_till     = @tree.learn_till.class
    @comment        = @tree.comment.class

    # btns
    @found.delete.on 'click', @remove
    @found.rem.on    'click', @onRemove
    @found.expand.on 'click', @onExpand

    # clear error
    @country.on       'focus',  => @country.hideError()
    @city.on          'focus',  => @city.hideError()
    @university.on    'focus',  => @university.hideError()
    @faculty.on       'focus',  => @faculty.hideError()
    @chair.on         'focus',  => @chair.hideError()
    @qualification.on 'focus',  => @qualification.hideError()
    @learn_from.on    'focus',  => @learn_from.hideError()
    @learn_till.on    'focus',  => @learn_till.hideError()

    # error div
    @country.setErrorDiv        @out_err_country
    @city.setErrorDiv           @out_err_city
    @university.setErrorDiv     @out_err_university
    @faculty.setErrorDiv        @out_err_faculty
    @chair.setErrorDiv          @out_err_chair
    @qualification.setErrorDiv  @out_err_qualification
    @learn_from.setErrorDiv     @out_err_period
    @learn_till.setErrorDiv     @out_err_period


  onExpand: (e) =>
    e.stopPropagation()
    if @container.is ':visible'
      @slideUp()
    else
      @slideDown()
    return false

  onRestore: =>
    if @is_removed
      @is_removed = false
      @dom.removeClass 'restore'
      @restore_block.hide 0, => @active_block.show()
    return false


  onRemove: (e) =>
    e.stopPropagation()
    if not @is_removed
      @slideUp =>
        name = @children.name.getValue()
        @is_removed = true
        @dom.addClass 'restore'
        @restore_name.text if name isnt '' then "Удалить предмет #{name.toUpperCase()}?" else "Удалить предмет?"
        @active_block.hide 0, => @restore_block.show()
    return false

  onRestore: =>
    if @is_removed
      @is_removed = false
      @dom.removeClass 'restore'
      @restore.hide 0, => @active.show()
    return false

  onRemove: (e) =>
    e.stopPropagation()
    if not @is_removed
      @slideUp =>
#        name = @children.name.getValue()
        @is_removed = true
        @dom.addClass 'restore'
#        @restore_name.text if name isnt '' then "Удалить предмет #{name.toUpperCase()}?" else "Удалить предмет?"
        @active.hide 0, => @restore.show()
    return false

  check_form : =>
    errs = @js.check @getData()
    for e in errs
      @parseError e
    return errs.length==0
  getValue : => @getData()
  setValue : (data={})=>
    @country.setValue       data.country  || ""
    @city.setValue          data.city     || ""
    @university.setValue    data.name     || ""
    @faculty.setValue       data.faculty  || ""
    @chair.setValue         data.chair    || ""
    @qualification.setValue data.qualification || ""
    @learn_from.setValue    data.learn_from || ""
    @learn_till.setValue    data.learn_till || ""
    @comment.setValue       data.comment    || ""
  getData : =>
    country         : @country.getValue()
    city            : @city.getValue()
    name            : @university.getValue()
    faculty         : @faculty.getValue()
    chair           : @chair.getValue()
    qualification   : @qualification.getValue()
    learn_from      : @learn_from.getValue()
    learn_till      : @learn_till.getValue()
    comment         : @comment.getValue()

  parseError : (err)=>
    switch err
      when "empty_country"
        @country.showError "Заполните страну"
      when "empty_city"
        showError "Заполните город"
      when "empty_university"
        showError "Заполните университет"
      when "empty_faculty"
        showError "Заполните факультет"
      when "empty_chair"
        showError "Заполните кафедру"
      when "empty_qualification"
        showError "Выберите статус"
      when "bad_country"
         @country.showError "Выберите страну из списка"
      when "bad_city"
        @city.showError "Выберите город из списка"
      when "bad_university"
        @university.showError "Выберите ВУЗ из списка"
      when "bad_faculty"
        @faculty.showError "Выберите факультет из списка"
      when "bad_chair"
        @chair.showError "Выберите кафедру из списка"
      when "bad_qualification"
        @qualification.showError "Выберите статус из списка"
