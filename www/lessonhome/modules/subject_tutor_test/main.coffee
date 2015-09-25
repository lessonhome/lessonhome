class @main
  Dom: =>
    @btn_expand = @found.expand
    @btn_remove = @found.rem
    @btn_restore = @found.restore

    @active_block = @found.active_block
    @restore_block = @found.restore_block
    @restore_name = @found.name_subject

    @students = @found.categories_of_students
    @container = @found.container
    @prices_place = @found.prices_place
    @price_group = @found.price_group
    @is_removed = false
    #####
    @btn_delete = @found.delete
    #####
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



    # div
    # err div fined
    #@out_err_course                 = @found.out_err_course
#      @out_err_group_learning         = @found.out_err_group_learning
#      @out_err_categories_of_students = @found.out_err_categories_of_students
#      @out_err_place                  = @found.out_err_place


#      subject = @tree
#      @subject_list = @tree.select_subject_field.class
    #@subject_tag = subject.subject_tag.class
#      @course = subject.course.class
#      @group_learning = subject.group_learning.content.group_people.class
#    @duration = subject.duration.class
#    @price_from = subject.price_slider.start.class
#    @price_till = subject.price_slider.end.class
#      @comments = subject.comments.class

#      @pre_school = subject.pre_school.class
#      @junior_school = subject.junior_school.class
#      @medium_school = subject.medium_school.class
#      @high_school = subject.high_school.class
#      @student = subject.student.class
#      @adult = subject.adult.class
#
#      @place_tutor = subject.place_tutor.trigger.class
#      @place_pupil = subject.place_pupil.trigger.class
#      @place_remote = subject.place_remote.trigger.class
#    @place_cafe = subject.place_cafe.class
  show : =>
    @training_direction = {
      "английский язык":['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'TOEFL','IELTS', 'FCE', 'TOEIC', 'Business English', 'GMAT', 'GRE', 'SAT'],
      "японский язык": ['JLPT', 'JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5'],
      "корейский язык": ['TOPIK', 'TOPIK I', 'TOPIK II'],
      "китайския язык": ['HSK', 'HSK Высший', 'HSK Начальный/средний', 'HSK Базовый'],
      "испанский язык": ['DELE', 'DELE A', 'DELE B', 'DELE C'],
      "франзузский язык": ['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'DELF', 'DELF A', 'DELF B', 'DALF'],
      "немецкий язык": ['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'DSH', 'TestDaF'],
      "итальянский язык": ['CILS', 'CILS B1', 'CILS B2', 'CILS C1', 'CILS C2'],
      "португальский язык": ['CEPRE-Bras', 'CEPRE-Bras Средний', 'CEPRE-Bras Выше среднейго', 'CEPRE-Bras Продвинутый', 'CEPRE-Bras Выше продвинутого'],
      "программирование": ['школьный курс', '3dMAX', 'Access', 'Adobe Flash', 'ArchiCad', 'assembler', 'AutoCAD', 'bash', 'basic', 'Borland C', 'C', 'c#', 'c++', 'CorelDraw', 'css', 'Deform-3D', 'delphi', 'Excel', 'FireBird', 'fortran', 'HTML', 'Illustrator', 'InDesign', 'Internet', 'java', 'JavaScript', 'Joomla', 'linux', 'LISP', 'MacOS', 'Maple', 'MathCAD', 'Matlab', 'MS Office', 'MySQL', 'Object Pascal', 'Objective-C', 'Outlook', 'pascal', 'perl', 'Photoshop', 'php', 'PowerPoint', 'python', 'QBasic', 'ruby', 'SEO (search engine optimization)', 'SolidWorks', 'SQL', 't-sql', 'TurboPascal', 'Unix', 'VB Pro', 'VBA', 'visual basic', 'Windows', 'Word', 'Wordpress', 'xml', 'алгоритмы', 'анимация', 'выпуклое программирование', 'дизайн веб-сайтов', 'компьютерная грамотность', 'компьютерная графика', 'линейное программирование', 'объемное моделирование', 'операционные системы', 'программирование', 'разработка веб-сайтов', 'РЕФАЛ', 'системное администрирование', 'подготовка к олимпиадам'],
      "музыка": [""],
      "начальная школа": [""],
      "логопеды": ["общий курс", "алалия", "аутизм", "афазия", "брадилалия", "все нарушения речи", "диагностика (обследование)", "дизартрия", "дизорфография", "дисграфия", "дислалия", "дислексия", "дисфония", "заикание", "ЗПРР", "ЗРР", "ЛГНР", "логоневроз", "логопедический массаж", "логоритмика", "ОНР", "ОНР при ЗПР", "постановка звуков", "ринолалия", "системное недоразвитие речи при ИН", "стертая дизартрия", "тахилалия", "ФД (фонетический дефект)", "ФНР (фонематическое недоразвитие речи)", "ФФН (фонетико-фонематическое недоразвитие)"],
      "default" : ['ЕГЭ','ОГЭ(ГИА)', 'подготовка к олимпиадам', 'школьный курс', 'вузовский курс']
    }
    @btn_expand.on 'click', (e) =>
      if @container.is ':visible'
        @slideUp()
      else
        @slideDown()

    @btn_restore.on 'click', (e) =>
      if @is_removed
        @is_removed = false
        @dom.removeClass 'restore'
        @restore_block.hide 0, => @active_block.show()

    @btn_remove.on 'click', (e) =>
      if not @is_removed
        @slideUp =>
          name = @children.name.getValue()
          @is_removed = true
          @dom.addClass 'restore'
          @restore_name.text if name isnt '' then "Предмет #{name.toUpperCase()} будет удален" else "Предмет будет удален"
          @active_block.hide 0, => @restore_block.show()

    @children.course.on 'end',=>
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

    @children.name.setErrorDiv @found.error_name
    #@course           .setErrorDiv @out_err_course
#      @group_learning   .setErrorDiv @out_err_group_learning
#      @pre_school       .setErrorDiv @out_err_categories_of_students
#      @place_tutor      .setErrorDiv @out_err_place
    #@course           .setErrorDiv @out_err_course
#    @group_learning   .setErrorDiv @out_err_group_learning

    # clear error
    #@course.on            'focus',  => @course.hideError()
#      @group_learning.on    'focus',  => @group_learning.hideError()
#      @pre_school.on        'change', => @pre_school.hideError()
#      @junior_school.on     'change', => @junior_school.hideError()
#      @medium_school.on     'change', => @medium_school.hideError()
#      @high_school.on       'change', => @high_school.hideError()
#      @student.on           'change', => @student.hideError()
#      @adult.on             'change', => @adult.hideError()
#      @place_tutor.on       'change', => @place_tutor.hideError()
#      @place_pupil.on       'change', => @place_pupil.hideError()
#      @place_remote.on      'change', => @place_remote.hideError()
#    @place_cafe.on        'change', => @place_cafe.hideError()

    @children.name.on 'change',(name)=>
      if name isnt ''
        if @training_direction[name]?
          direction = @training_direction[name]
        else
          direction = @training_direction['default']
        @children.course.reset()
        @children.course.setItems direction
        @slideDown()

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

  getValue : =>
    result = {}
    $.each @children, (key, cl) ->
      result[key] = cl.getValue?()
      return true
    return result
  setValue : (data) =>
    if data isnt undefined
      $.each @children, (key, cl) ->
        if data[key] isnt undefined then cl.setValue? data[key]
  resetError : () =>
    @parseError({correct: true})
  parseError : (errors) =>
#    return if @is_removed is true
#    if errors.correct isnt true then @slideDown() else @slideUp()
    if errors['name']? then @children.name.showError 'Вы не выбрали предмет'

    if errors['students']?
      @showErrBlock @students, 'Выберите категории учеников'
    else
      @hideErrBlock @students

    if errors['places']?
      @showErrBlock @prices_place, 'Укажите хотябы одно место для занятий'
    else
      @hideErrBlock @prices_place

    for key in ["place_tutor", "place_pupil", "place_remote"]
      if errors[key]?['prices']?
        @showErrBlock @children[key].dom.parent(), 'Укажите цену за занятие (минимум одну)'
      else @hideErrBlock @children[key].dom.parent()
    if errors['group_learning']?
      @showErrBlock @price_group, 'Выберите численность группы'
    else
      @hideErrBlock @price_group