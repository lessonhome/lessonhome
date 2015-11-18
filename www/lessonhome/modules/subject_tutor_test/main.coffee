class @main
  Dom: =>
    @panel = @found.panel

    @btn_expand = @found.expand
    @btn_remove = @found.rem
    @btn_restore = @found.restore
    @btn_delete = @found.delete
    @btn_copy = @found.copy_prev_settings

    @active_block = @found.active_block
    @restore_block = @found.restore_block
    @restore_name = @found.name_subject

    @students = @found.categories_of_students
    @container = @found.container
    @prices_place = @found.prices_place
    @price_group = @found.price_group
    @out_err_course = @found.out_err_course

    @is_removed = false

    @children = {
      name : @tree.select_subject_field.class

      course : @tree.course.class

      pre_school : @tree.pre_school.class
      junior_school : @tree.junior_school.class
      medium_school : @tree.medium_school.class
      high_school : @tree.high_school.class
      student : @tree.student.class
      adult : @tree.adult.class

      place_tutor : @tree.place_tutor.class
      place_pupil : @tree.place_pupil.class
      place_remote : @tree.place_remote.class
      group_learning : @tree.group_learning.class

      comments : @tree.comments.class
    }

    @observer = null

  show : =>
    @btn_expand.on 'click', @onExpand
    @btn_restore.on 'click', @onRestore
    @btn_remove.on 'click', @onRemove
    @btn_delete.on 'click', @onDelete
    @children.course.on 'end', @onTags
    @children.name.on 'focus', @onFocusName
    @children.name.on 'change', @onChangeName
    @btn_copy.on 'click', @onCopy
    @restore_block.on 'click', (e) -> e.stopPropagation()

    @children.name.setErrorDiv @found.error_name
    @children.course.setErrorDiv @out_err_course

  onCopy : => @notifyObserver 'copy'
  onFocusName : => @notifyObserver 'focus'

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
      @panel.removeClass 'restore'
    return false

  onRemove: (e) =>
    e.stopPropagation()
    if not @is_removed
      @slideUp =>
        name = @children.name.getValue()
        @is_removed = true
        @panel.addClass 'restore'
        @restore_name.text if name isnt '' then "Удалить предмет #{name.toUpperCase()}?" else "Удалить предмет?"
    return false

  onDelete : =>
    @btn_copy.off 'click', @onCopy
    @btn_delete.off 'click', @onDelete
    @children.name.off 'focus', @onFocusName
    @btn_expand.off 'click', @onExpand
    @btn_restore.off 'click', @onRestore
    @btn_remove.off 'click', @onRemove
    @children.course.off 'end', @onTags
    @children.name.off 'change', @onChangeName
    @notifyObserver 'del'
    return false

  onTags: =>
    arr = @children.course.getValue()
    len = 0
    narr = []
    for key,val of arr
      narr.push(val.split(',')...)
      len++
    arr = []
    arr.push(val.split(';')...) for key,val of narr
    if arr.length > len
      @children.course.setValue arr

  onChangeName: (name) =>
    if @training_direction? and name isnt ''
      if @training_direction[name]?
        direction = @training_direction[name]
      else
        direction = @training_direction['default']
      @children.course.setItems direction

  setDirection : (direct) => @training_direction = direct
  setNames : (names) => @children.name.setItems names


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

  slideUp :(callback) =>
    @container.slideUp 500, (e) =>
      @btn_expand.removeClass 'active'
      callback? e
  slideDown :(callback) =>
    @container.slideDown 500, (e) =>
      @btn_expand.addClass 'active'
      callback? e

  showSettings : =>
    @container.show()
    @btn_expand.addClass 'active'

  hideSettings : =>
    @container.hide()
    @btn_expand.removeClass 'active'

  notifyObserver : (message) => @observer?.handleEvent? @, message
  setObserver : (observer) => @observer = observer

  getValue : =>
    result = {}
    $.each @children, (key, cl) ->
      result[key] = cl.getValue?()
      return true
    return result

  setValue : (data={}) =>
    @panel.removeClass 'restore'
    $.each @children, (key, cl) ->
      cl.setValue? data[key]

  copySettings : (elem, copied = []) =>
    settings = elem.getValue()

    if copied.length == 0
      @setValue settings
    else
      current_settings = @getValue()
      for key in copied
        current_settings[key] = settings[key]
      @setValue current_settings

  resetError : () =>
    @parseError({correct: true})

  parseError : (errors) =>
#    return if @is_removed is true
#    if errors.correct isnt true then @slideDown() else @slideUp()
    if errors['name']?
      if errors['name'] is 'empty_field' then @children.name.showError 'Вы не выбрали предмет'
      else if errors['name'] is 'match_name' then @children.name.showError 'Такой предмет уже существует'
    else
      @children.name.hideError()
    if errors['course']?
      if errors['course'] is 'long_tag' then @children.course.showError 'Максимальная длинна одного тега - 80 символов'
      else if errors['course'] is 'to_many_tags' then @children.course.showError 'Пожалуйста, уменьшите количество тегов'
    else
      @children.course.hideError()
    if errors['students']?
      @showErrBlock @students, 'Выберите категории учеников'
    else
      @hideErrBlock @students

    if errors['places']?
      @showErrBlock @prices_place, 'Укажите хотя бы одно место для занятий'
    else
      @hideErrBlock @prices_place

    for key in ["place_tutor", "place_pupil", "place_remote"]
      if errors[key]?['prices']?
        @showErrBlock @children[key].dom.parent(), 'Назначьте цену за занятие'
      else @hideErrBlock @children[key].dom.parent()
    if errors['group_learning']?
      @showErrBlock @price_group, 'Выберите численность группы'
    else
      @hideErrBlock @price_group
