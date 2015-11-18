class @main
  Dom :=>
    @students = @found.categories_of_students
    @prices_place = @found.prices_place
    @price_group = @found.price_group

    @course = @tree.course.class
    @pre_school = @tree.pre_school.class
    @junior_school = @tree.junior_school.class
    @medium_school = @tree.medium_school.class
    @high_school = @tree.high_school.class
    @student = @tree.student.class
    @adult = @tree.adult.class
    @place_tutor = @tree.place_tutor.class
    @place_pupil = @tree.place_pupil.class
    @place_remote = @tree.place_remote.class
    @group_learning = @tree.group_learning.class
    @comments = @tree.comments.class

  show : =>
    @course.setErrorDiv @found.out_err_course

    @course.on 'end', @onTags
    @found.copy_prev_settings.on 'click',  => @event 'copy'

  onTags: =>
    arr = @course.getValue()
    len = 0
    narr = []
    for key,val of arr
      narr.push(val.split(',')...)
      len++
    arr = []
    arr.push(val.split(';')...) for key,val of narr
    if arr.length > len
      @course.setValue arr

  event : (message) => @emit 'event', message

  getValue : =>
    course : @course.getValue()
    pre_school : @pre_school.getValue()
    junior_school : @junior_school.getValue()
    medium_school : @medium_school.getValue()
    high_school : @high_school.getValue()
    student : @student.getValue()
    adult : @adult.getValue()
    place_tutor : @place_tutor.getValue()
    place_pupil : @place_pupil.getValue()
    place_remote : @place_remote.getValue()
    group_learning : @group_learning.getValue()
    comments : @comments.getValue()
    
  setValue : (data = {}) =>
    @course.setValue data.course
    @pre_school.setValue data.pre_school
    @junior_school.setValue data.junior_school
    @medium_school.setValue data.medium_school
    @high_school.setValue data.high_school
    @student.setValue data.student
    @adult.setValue data.adult
    @place_tutor.setValue data.place_tutor
    @place_pupil.setValue data.place_pupil
    @place_remote.setValue data.place_remote
    @group_learning.setValue data.group_learning
    @comments.setValue data.comments

  showErrBlock : (block, text) =>
    if not block.is '.error'
      block.addClass 'error'
      text = $("<div class='err'>" + text + "</div>").hide()
      block.after text
      text.slideDown 200

  hideErrBlock : (block) =>
    block.removeClass 'error'
    block.next('.err').slideUp 200, ->
      $(this).remove()

  setCourse : (items) => @course.setItems items


  showErrors : (errors) =>
    if errors['course']? then @course.showError errors['course'] else @course.hideError()
    if errors['students']? then @showErrBlock @students, errors['students'] else @hideErrBlock @students
    if errors['places']? then @showErrBlock @prices_place, errors['places'] else @hideErrBlock @prices_place

    for key in ["place_tutor", "place_pupil", "place_remote"]
      if errors[key]?['prices']?
        @showErrBlock @[key].dom.parent(), errors[key]['prices']
      else @hideErrBlock @[key].dom.parent()

    if errors['group_learning']? then @showErrBlock @price_group, errors['group_learning'] else @hideErrBlock @price_group