
class @main
  Dom: =>
    # control elements
    @hide_el      = @found.hide
    @del          = @found.delete
    # div
    @container    = @found.container
    @bg_block     = @found.bg_block
    # err div fined
    @out_err_course                 = @found.out_err_course
    @out_err_group_learning         = @found.out_err_group_learning
    @out_err_categories_of_students = @found.out_err_categories_of_students
    @out_err_place                  = @found.out_err_place

  show: =>
    # hide and delete function subject details
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

    # fined div error
    @course           .setErrorDiv @out_err_course
    @group_learning   .setErrorDiv @out_err_group_learning
    @pre_school       .setErrorDiv @out_err_categories_of_students
    @place_tutor      .setErrorDiv @out_err_place
    @course           .setErrorDiv @out_err_course
    @group_learning   .setErrorDiv @out_err_group_learning


    # clear error
    @course.on            'focus',  => @course.hideError()
    @group_learning.on    'focus',  => @group_learning.hideError()
    @pre_school.on        'change', => @pre_school.hideError()
    @junior_school.on     'change', => @junior_school.hideError()
    @medium_school.on     'change', => @medium_school.hideError()
    @high_school.on       'change', => @high_school.hideError()
    @student.on           'change', => @student.hideError()
    @adult.on             'change', => @adult.hideError()
    @place_tutor.on       'change', => @place_tutor.hideError()
    @place_pupil.on       'change', => @place_pupil.hideError()
    @place_remote.on      'change', => @place_remote.hideError()
    @place_cafe.on        'change', => @place_cafe.hideError()

      categories_of_students  : @categories_of_students