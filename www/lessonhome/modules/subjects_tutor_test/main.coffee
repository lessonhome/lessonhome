
class @main
  Dom : ->
    @btn_add = @found.btn_add
    @container = @found.container
    @data = @tree.data
    @subject = @tree.subject.class
    @default_subjects = @tree.default_subjects
  show : =>
    @subjects = []
#    @addNewSubject = do =>
#      i = 0
#      return (key, values) =>
#        obj = @subject.$clone()
#        if key is undefined
#          key = ++i
#        else if key > i
#          i = key
#
#        if values then obj.setValue values
#        @subjects[key] =  obj
##        obj.btn_delete.on 'click', =>
##          delete @subjects[key]
##          obj.remove()
#        @container.append $('<div class="block"></div>').append obj.dom
#        return obj


    for key, values of @data
      @addNewSubject values


    @btn_add.click =>
      if @btn_add.is '.active'
        @btn_add.removeClass 'active'
        obj = @addNewSubject null, =>
          obj.slideDown()
          @btn_add.addClass 'active'




#    for i,subject of @tree.subjects
#      @subjects[i] = {}
#      @subjects[i].class = subject.class
#      #@subjects[i].subject_tag = subject.subject_tag.class
#      @subjects[i].course = subject.course.class
#      @subjects[i].group_learning = subject.group_learning.class
##      @subjects[i].duration = subject.duration.class
##      @subjects[i].price_from = subject.price_slider.start.class
##      @subjects[i].price_till = subject.price_slider.end.class
#      @subjects[i].comments = subject.comments.class
#
#      @subjects[i].pre_school = subject.pre_school.class
#      @subjects[i].junior_school = subject.junior_school.class
#      @subjects[i].medium_school = subject.medium_school.class
#      @subjects[i].high_school = subject.high_school.class
#      @subjects[i].student = subject.student.class
#      @subjects[i].adult = subject.adult.class
#      @subjects[i].place_tutor = subject.place_tutor.class
#      @subjects[i].place_pupil = subject.place_pupil.class
#      @subjects[i].place_remote = subject.place_remote.class
#      @subjects[i].place_cafe = subject.place_cafe.class

  save : => Q().then =>
    data = @getData()
    errors = @js.check data
    if errors.correct is true
      return @$send('./save', data).then @onReceive
    else
      @parseError errors
      return false

  addNewSubject : (values, callback) =>
    obj = @subject.$clone()
    if values then obj.setValue values
    do =>
      i = @subjects.length
      @subjects.push obj
      obj.btn_delete.on 'click', =>
        @subjects.splice i, 1
        obj.btn_delete.off 'click'
        obj.dom.closest('.block').slideUp 200, ->
          obj.dom.remove()
    block = $('<div class="block"></div>').append(obj.dom).hide()
    obj.container.stop(true, true).show()
    @container.append block
    block.slideDown 300, callback
    return obj

  onReceive : ({status,errs,err})=>
    console.log status, errs, err
    if err?
      errs?={}
      errs['other'] = err
    if status=='success'
      for cl in @subjects
        cl.resetError()
      return true

    if not errs.correct
      @parseError errs
    return false

  parseError : (errors) =>
    for cl, i in @subjects
      if not cl.is_removed
        if errors[i]?
          if errors[i].correct isnt true then cl.slideDown()
          cl.parseError errors[i]
        else
          cl.resetError()
          if errors.correct is false then cl.slideUp()


#  check_form : =>
#    errs = @js.check @getData()
#    for i,subject_val of @subjects
#      console.log 'omg',subject_val.class.found.subject_tag.text()
#      unless subject_val.class.found.subject_tag.text()
#        errs.push 'empty_subject':i
#      #if !subject_val.course.exists() && subject_val.course.getValue() != 0
#      #  errs.push 'bad_course':i
#      #if !@qualification.exists() && @qualification.getValue() != 0
#      #  errs.push 'bad_qualification'
#      if !subject_val.group_learning.exists() && subject_val.group_learning.getValue() != 0
#        errs.push 'bad_group_learning':i
#
#    for e in errs
#      if typeof e == 'object'
#        _e = Object.keys(e)[0]
#        i = e[_e]
#      else
#        _e = e
#        i = null
#      @parseError _e, i
#    return errs.length==0

  getData : =>
    data = {
      subjects_val : {}
    }
    for sub, i in @subjects
      if not sub.is_removed then data.subjects_val[i] = sub.getValue()
    return data

#    @subjects_val = {}
#    for i,subject of @subjects
#      @subjects_val[i] = {}
#      @subjects_val[i].name = subject.class.found.subject_tag.text()
#      #@subjects_val[i].subject_tag = subject.subject_tag.getValue()
#      @subjects_val[i].course = subject.course.getValue()
#      @subjects_val[i].group_learning = subject.group_learning.getValue()
##      @subjects_val[i].duration = subject.duration.getValue()
##      @subjects_val[i].price_from = subject.price_from.getValue()
##      @subjects_val[i].price_till = subject.price_till.getValue()
#      @subjects_val[i].comments = subject.comments.getValue()
#
#      @subjects_val[i].pre_school = subject.pre_school.getValue()
#      @subjects_val[i].junior_school = subject.junior_school.getValue()
#      @subjects_val[i].medium_school = subject.medium_school.getValue()
#      @subjects_val[i].high_school = subject.high_school.getValue()
#      @subjects_val[i].student = subject.student.getValue()
#      @subjects_val[i].adult = subject.adult.getValue()
#      @subjects_val[i].place_tutor = subject.place_tutor.getValue()
#      @subjects_val[i].place_pupil = subject.place_pupil.getValue()
#      @subjects_val[i].place_remote = subject.place_remote.getValue()
##      @subjects_val[i].place_cafe = subject.place_cafe.getValue()
#    return {
#      subjects_val : @subjects_val
#    }
  ###
    @categories_of_students = [@pre_school.getValue(),@junior_school.getValue(), @medium_school.getValue(), @high_school.getValue(), @student.getValue(), @adult.getValue()]
    @place = [@place_tutor.getValue(),@place_pupil.getValue(), @place_remote.getValue(),@place_cafe.getValue()]
    return {
    subject_tag             : @subject_tag.getValue()
    course                  : @course.getValue()
    #qualification           : @qualification.getValue()
    group_learning          : @group_learning.getValue()
    comments                : @comments.getValue()
    categories_of_students  : @categories_of_students
    duration                : @duration.getValue()
    price_from              : @price_from.getValue()
    price_till              : @price_till.getValue()
    place                   : @place
    }
  ###

#  parseError : (err) =>
#    for index, subject of @subjects

#  parseError : (err, i)=>
#    switch err
## short
#      when "short_duration"
#        @subjects[i].duration.showError "Введите время занятия"
#      when 'empty_subject'
#        console.log 'empty'
#        @tree.select_subject_field.class.setErrorDiv @dom.find '>.err>div'
#        @tree.select_subject_field.class.showError "Выберите предмет"
## long
#      when "long_duration"
#        @subjects[i].duration.showError ""
#
##empty
#      when "empty_duration"
#        @subjects[i].duration.showError ""
##when "empty_course"
##  @subjects[i].course.setErrorDiv @out_err_course
##  @subjects[i].course.showError "Выберите курс"
##when "empty_qualification"
##  @qualification.setErrorDiv @out_err_qualification
##  @qualification.showError "Выберите квалификацию"
#      when "empty_group_learning"
#        @subjects[i].group_learning.setErrorDiv @out_err_group_learning
#        @subjects[i].group_learning.showError "Выберите групповые занятия"
#      when "empty_categories_of_students"
#        @subjects[i].pre_school.setErrorDiv @out_err_categories_of_students
#        @subjects[i].pre_school.showError "Выберите категории учеников"
#      when "empty_place"
#        @subjects[i].place_tutor.setErrorDiv @out_err_place
#        @subjects[i].place_tutor.showError "Выберите место занятий"
#
##correct
##when "bad_course"
##  @subjects[i].course.setErrorDiv @out_err_course
##  @subjects[i].course.showError "Выберите корректный курс"
##when "bad_qualification"
##  @qualification.setErrorDiv @out_err_qualification
##  @course.showError "Выберите корректную квалификацию"
#      when "bad_group_learning"
#        @subjects[i].group_learning.setErrorDiv @out_err_course
#        @subjects[i].group_learning.showError "Выберите корректный курс"