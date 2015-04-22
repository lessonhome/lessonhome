
class @main
  Dom: =>
    @hide_el      = @found.hide
    @del          = @found.delete
    @container    = @found.container
    @bg_block     = @found.bg_block

    @out_err_course         = @found.out_err_course
    @out_err_qualification  = @found.out_err_qualification
    @out_err_group_learning = @found.out_err_group_learning

  show: =>
    @hide_el.on 'click', =>
      text = @hide_el.text()
      if text == 'Свернуть'
        @container.hide()
        text = @hide_el.text('Развернуть')
      if text == 'Развернуть'
        @container.show()
        text = @hide_el.text('Свернуть')
    @del.on 'click', =>
      @bg_block.remove()



    @subject_tag    = @tree.subject_tag.class
    # drop_down_list
    @course         = @tree.course.class
    @qualification  = @tree.qualification.class
    @group_learning = @tree.group_learning.class

    # input
    @duration = @tree.duration.class
    @price_from = @tree.price_slider.start.class
    @price_till = @tree.price_slider.end.class

    # text area
    @comments       = @tree.comments.class


    # checkboxes
    @pre_school    = @tree.pre_school.class
    @junior_school = @tree.junior_school.class
    @medium_school = @tree.medium_school.class
    @high_school   = @tree.high_school.class
    @student       = @tree.student.class
    @adult         = @tree.adult.class

    @place_tutor  = @tree.place_tutor.class
    @place_pupil  = @tree.place_pupil.class
    @place_remote = @tree.place_remote.class
    @place_cafe   = @tree.place_cafe.class




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
    if !@course.exists() && @course.getValue() != 0
      errs.push 'bad_course'
    if !@qualification.exists() && @qualification.getValue() != 0
      errs.push 'bad_qualification'
    if !@group_learning.exists() && @group_learning.getValue() != 0
      errs.push 'bad_group_learning'

    for e in errs
      @parseError e
    return errs.length==0
    return true


  getData : =>
    categories_of_students = [@pre_school.getValue(),@junior_school.getValue(), @medium_school.getValue(), @high_school.getValue(), @student.getValue(), @adult.getValue()]
    place = [@place_tutor.getValue(),@place_pupil.getValue(), @place_remote.getValue(),@place_cafe.getValue()]
    return {
      subject_tag             : @subject_tag.getValue()
      course                  : @course.getValue()
      qualification           : @qualification.getValue()
      group_learning          : @group_learning.getValue()
      comments                : @comments.getValue()
      categories_of_students  : categories_of_students
      duration                : @duration.getValue()
      price_from              : @price_from.getValue()
      price_till              : @price_till.getValue()
      place                   : place
    }


  parseError : (err)=>

    switch err
    # short
      when "short_duration"
        @duration.showError "Слишком короткое имя"

    # long
      when "long_duration"
        @duration.showError "Слишком длинное имя"

    #empty
      when "empty_duration"
        @duration.showError "Заполните имя"
      when "empty_course"
        @course.setErrorDiv @out_err_course
        @course.showError "Выберите курс"
      when "empty_qualification"
        @qualification.setErrorDiv @out_err_qualification
        @qualification.showError "Выберите квалификацию"
      when "empty_group_learning"
        @group_learning.setErrorDiv @out_err_course
        @group_learning.showError "Выберите групповые занятия"

    #correct
      when "bad_course"
        @course.setErrorDiv @out_err_course
        @course.showError "Выберите корректный курс"
      when "bad_qualification"
        @qualification.setErrorDiv @out_err_qualification
        @course.showError "Выберите корректную квалификацию"
      when "bad_group_learning"
        @group_learning.setErrorDiv @out_err_course
        @group_learning.showError "Выберите корректный курс"
      else
        alert 'die'

