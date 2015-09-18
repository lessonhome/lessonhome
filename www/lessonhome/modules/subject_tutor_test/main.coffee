class @main
  Dom: =>
    @btn_expand = @found.expand
    @btn_remove = @found.remove
    @container = @found.container
    # div
    # err div fined
    #@out_err_course                 = @found.out_err_course
    @out_err_group_learning         = @found.out_err_group_learning
    @out_err_categories_of_students = @found.out_err_categories_of_students
    @out_err_place                  = @found.out_err_place

    subject = @tree
    #@subject_tag = subject.subject_tag.class
    @course = subject.course.class
    @group_learning = subject.group_learning.content.group_people.class
#    @duration = subject.duration.class
#    @price_from = subject.price_slider.start.class
#    @price_till = subject.price_slider.end.class
    @comments = subject.comments.class

    @pre_school = subject.pre_school.class
    @junior_school = subject.junior_school.class
    @medium_school = subject.medium_school.class
    @high_school = subject.high_school.class
    @student = subject.student.class
    @adult = subject.adult.class

    @place_tutor = subject.place_tutor.trigger.class
    @place_pupil = subject.place_pupil.trigger.class
    @place_remote = subject.place_remote.trigger.class
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
    @btn_expand.click =>
      if @container.is ':visible'
        @hideContainer()
      else
        @showContainer()

    #@course           .setErrorDiv @out_err_course
    @group_learning   .setErrorDiv @out_err_group_learning
    @pre_school       .setErrorDiv @out_err_categories_of_students
    @place_tutor      .setErrorDiv @out_err_place
    #@course           .setErrorDiv @out_err_course
#    @group_learning   .setErrorDiv @out_err_group_learning


    # clear error
    #@course.on            'focus',  => @course.hideError()
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
#    @place_cafe.on        'change', => @place_cafe.hideError()

    @subject_list = @tree.select_subject_field.class
    @subject_list.on 'end',(name)=>
      console.log 'end',name
      if name isnt ''
        if @training_direction[name]?
          direction = @training_direction[name]
        else
          direction = @training_direction['default']
        console.log direction
        @course.setItems direction
        @showContainer()

  hideContainer : =>
    @container.slideUp 300
  showContainer : =>
    @container.slideDown 300
#    @classes = [
#      @tree.place_tutor.class,
#      @tree.place_pupil.class,
#      @tree.place_remote.class,
#      @tree.group_learning.class
#    ]
##    setInterval @updateAll, 100
#    @initAll()
#  initAll : =>
#    $.each @classes, (i, el) =>
#      el.block.hide()
#      el.checkbox.dom.click ->
#        if el.checkbox.getValue()
#          el.block.slideUp 200
#        else
#          el.block.slideDown 200
#      el.initAll?()
#  updateAll : =>
#    $.each @classes, (i, cl) => cl.updateAll?()
