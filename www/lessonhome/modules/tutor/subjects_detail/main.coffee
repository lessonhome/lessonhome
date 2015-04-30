
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

    subject = @tree
    #@subject_tag = subject.subject_tag.class
    @course = subject.course.class
    @group_learning = subject.group_learning.class
    @duration = subject.duration.class
    @price_from = subject.price_slider.start.class
    @price_till = subject.price_slider.end.class
    @comments = subject.comments.class

    @pre_school = subject.pre_school.class
    @junior_school = subject.junior_school.class
    @medium_school = subject.medium_school.class
    @high_school = subject.high_school.class
    @student = subject.student.class
    @adult = subject.adult.class
    @place_tutor = subject.place_tutor.class
    @place_pupil = subject.place_pupil.class
    @place_remote = subject.place_remote.class
    @place_cafe = subject.place_cafe.class
 


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
  showName : (name)=>
    return unless name
    @found.subject_tag.text(name)
    @found.bg_block.show()
    @tree.price_slider.class.recheck()


