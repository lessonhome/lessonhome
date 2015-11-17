
class @main
  Dom : ->
    @btn_add = @found.btn_add
    @container = @found.container
    @data = @tree.data
    @subject = @tree.subject.class
    @names_subjects = @tree.default_subjects
    @error_empty = @found.error_empty
  show : =>
    @training_direction = {
      "английский язык":['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'TOEFL','IELTS', 'FCE', 'TOEIC', 'Business English', 'GMAT', 'GRE', 'SAT'],
      "японский язык": ['JLPT', 'JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5'],
      "корейский язык": ['TOPIK', 'TOPIK I', 'TOPIK II'],
      "китайский язык": ['HSK', 'HSK Высший', 'HSK Начальный/средний', 'HSK Базовый'],
      "испанский язык": ['DELE', 'DELE A', 'DELE B', 'DELE C'],
      "французский язык": ['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'DELF', 'DELF A', 'DELF B', 'DALF'],
      "немецкий язык": ['ЕГЭ', 'ОГЭ(ГИА)', 'Разговорный', 'с нуля', 'DSH', 'TestDaF'],
      "итальянский язык": ['CILS', 'CILS B1', 'CILS B2', 'CILS C1', 'CILS C2'],
      "португальский язык": ['CEPRE-Bras', 'CEPRE-Bras Средний', 'CEPRE-Bras Выше среднейго', 'CEPRE-Bras Продвинутый', 'CEPRE-Bras Выше продвинутого'],
      "программирование": ['школьный курс', '3dMAX', 'Access', 'Adobe Flash', 'ArchiCad', 'assembler', 'AutoCAD', 'bash', 'basic', 'Borland C', 'C', 'c#', 'c++', 'CorelDraw', 'css', 'Deform-3D', 'delphi', 'Excel', 'FireBird', 'fortran', 'HTML', 'Illustrator', 'InDesign', 'Internet', 'java', 'JavaScript', 'Joomla', 'linux', 'LISP', 'MacOS', 'Maple', 'MathCAD', 'Matlab', 'MS Office', 'MySQL', 'Object Pascal', 'Objective-C', 'Outlook', 'pascal', 'perl', 'Photoshop', 'php', 'PowerPoint', 'python', 'QBasic', 'ruby', 'SEO (search engine optimization)', 'SolidWorks', 'SQL', 't-sql', 'TurboPascal', 'Unix', 'VB Pro', 'VBA', 'visual basic', 'Windows', 'Word', 'Wordpress', 'xml', 'алгоритмы', 'анимация', 'выпуклое программирование', 'дизайн веб-сайтов', 'компьютерная грамотность', 'компьютерная графика', 'линейное программирование', 'объемное моделирование', 'операционные системы', 'программирование', 'разработка веб-сайтов', 'РЕФАЛ', 'системное администрирование', 'подготовка к олимпиадам'],
      "музыка": [""],
      "начальная школа": [""],
      "логопеды": ["общий курс", "алалия", "аутизм", "афазия", "брадилалия", "все нарушения речи", "диагностика (обследование)", "дизартрия", "дизорфография", "дисграфия", "дислалия", "дислексия", "дисфония", "заикание", "ЗПРР", "ЗРР", "ЛГНР", "логоневроз", "логопедический массаж", "логоритмика", "ОНР", "ОНР при ЗПР", "постановка звуков", "ринолалия", "системное недоразвитие речи при ИН", "стертая дизартрия", "тахилалия", "ФД (фонетический дефект)", "ФНР (фонематическое недоразвитие речи)", "ФФН (фонетико-фонематическое недоразвитие)"],
      "default" : ['ЕГЭ','ОГЭ(ГИА)', 'подготовка к олимпиадам', 'школьный курс', 'вузовский курс']
    }

    @copied_settings = [
      'pre_school'
      'junior_school'
      'medium_school'
      'high_school'
      'student'
      'adult'
      'place_tutor'
      'place_pupil'
      'place_remote'
      'group_learning'
    ]

    @subjects = [@subject]

    for key, values of @data
      if key == '0'
        sub = @subject
      else
        sub = @subject.$clone()
        @subjects.push sub
        sub.setValue values
        @container.append $('<div class="block">').append(sub.dom)
      sub.setDirection @training_direction
      sub.flag = false
      sub.setObserver @
#      @addNewSubject(values).show()


#    if @subjects.length is 0 then @addNewSubject(null, true).show()

    @btn_add.addClass('active').click =>
      if @btn_add.is '.active'
        @btn_add.removeClass 'active'
        @add()
        @emptyErrorHide()
        @btn_add.addClass 'active'

    $(document).on 'click', =>
      for sub in @subjects
        if sub.is_removed is true
          sub.onRestore()

  handleEvent : (observable, message) =>
    switch message
      when 'copy'
        i = @getIndex observable
        if i > 0 then observable.copySettings @subjects[i - 1], @copied_settings
      when 'del'
        @subjects.splice @getIndex(observable), 1
        observable.dom.closest('.block').slideUp 200, -> $(@).remove()
      when 'focus'
        observable.setNames @getNames()

  getIndex : (sub)  =>
    sub.flag = true
    for _sub, i in @subjects
      if _sub.flag is true
        _sub.flag = false
        if sub.flag is false then break
    if sub.flag is true
      sub.flag = false
      return -1
    return i
  getNames : =>
    exist = {}
    names = []
    for subject in @subjects
      if (value = subject.children.name.getValue()) isnt ''
        exist[value.toLowerCase()] = true
    for i, name of @names_subjects
      names.push(name.text) if exist[name.text.toLowerCase()] isnt true
    return names

  save : => do Q.async =>
    data = @getData()
    errors = @js.check data
    if errors.correct is true
      return @onReceive yield @$send './save',data
    else
      @parseError errors
      return false

  add :  =>
    obj = @subject.$clone()
    obj.setValue()
    obj.setDirection @training_direction
    obj.setObserver @

    obj.flag = false
    @subjects.push obj

    obj.showSettings()
    block = $('<div class="block"></div>').hide().append obj.dom
    if @subjects.length == 0 then obj.btn_copy.hide()
    @container.append block
    block.slideDown 400

  onReceive : ({status,errs,err})=>
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

  emptyErrorShow : (text) =>
    @error_empty.text(text).slideDown 200

  emptyErrorHide : =>
    @error_empty.slideUp 200

  parseError : (errors) =>
    if errors['empty']?
      @emptyErrorShow "Добавьте хотя бы один предмет."
    else
      @emptyErrorHide()
#      i = 0
      for cl, i in @subjects
#        if not cl.is_removed
        if errors[i]?
          if errors[i].correct isnt true
            cl.onRestore()
            cl.slideDown()
          cl.parseError errors[i]
        else
          cl.resetError()
          if errors.correct is false then cl.slideUp()
#          i++

  getData : =>
    data = {
      subjects_val : {}
    }
#    i = 0
    for sub, i in @subjects
#      if not sub.is_removed then
      data.subjects_val[i] = sub.getValue()
    return data
