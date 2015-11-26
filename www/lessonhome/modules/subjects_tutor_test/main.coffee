
class @main

  Dom : =>
    @test = @tree.test.class
  show : =>
    @default_subjects = @tree.default_subjects
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

    @copy_settings = [
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

    @test.on 'fs_title', (elem) => elem.title.setItems @getNames()
    @test.on 'ch_title', (elem) => @setDirection elem

    @test.on 'copy', (elem) =>
      prev_form = @test.elements[@test.getIndex(elem) - 1].form.getValue()
      curr_form = elem.form.getValue()
      curr_form[key] = prev_form[key] for key in @copy_settings
      elem.form.setValue curr_form

    @test.on 'rem_first', => @test.elements[0]?.form.hideCopy()

    @test.on 'pushed', (elem) =>
      @test.hideErrEmpty()
      @setDirection elem
      if @test.elements.length > 1 then elem.form.showCopy()

    @test.on 'preremove', (elem) =>
      name = elem.title.getValue()
      elem.text_restore.text if name isnt '' then "Удалить предмет #{name.toUpperCase()}?" else "Удалить предмет?"

    $('html').on 'click', => @test.eachElem -> @onRestore()

    setTimeout(
        =>
          @test.add(val).show() for key, val of @tree.data when key != '0'
        , 0
    )

  getNames : =>
    exist = {}
    names = []
    @test.eachElem ->
      if (value = @title.getValue()) isnt '' then exist[value.toLowerCase()] = true
    for i, name of @default_subjects
      names.push(name.text) if exist[name.text.toLowerCase()] isnt true
    return names

  setDirection : (elem) =>
    name = elem.title.getValue()
    if @training_direction? and name isnt ''
      if @training_direction[name]?
        direction = @training_direction[name]
      else
        direction = @training_direction['default']
      elem.form.setCourse direction

  getValue : =>
    result = {}
    @test.eachElem (i) -> result[i] = @getValue()
    return result

  interpretError : (errors = {}) =>
    result = {}
#    return result if errors.correct is true
    if errors['name'] is 'empty_field' then result['name'] = 'Вы не выбрали предмет'
    else if errors['name'] is 'match_name' then result['name'] = 'Такой предмет уже существует'

    if errors['course'] is 'long_tag' then result['course'] = 'Максимальная длинна одного тега - 80 символов'
    else if errors['course'] is 'to_many_tags' then result['course'] = 'Пожалуйста, уменьшите количество тегов'

    if errors['students']? then result['students'] = 'Выберите категории учеников'

    if errors['places']? then result['places'] = 'Укажите хотя бы одно место для занятий'
    for key in ["place_tutor", "place_pupil", "place_remote"]
      if errors[key]?['prices']?
        result[key] = {}
        result[key]['prices'] = 'Назначьте цену за занятие'

    if errors['group_learning']? then result['group_learning'] = 'Выберите численность группы'
    return result

  getData : => subjects_val : @getValue()

  showErrors : (errors) =>
    that = @
    if errors['empty']?
      @test.showErrEmpty "Добавьте хотя бы один предмет."
    else
      @test.hideErrEmpty()
      @test.eachElem (i) ->
        if errors[i]? then @slideDown() else @slideUp()
        @showErrors that.interpretError(errors[i])

  save : => do Q.async =>
    data = @getData()
    errors = @js.check data
    if errors.correct is true
      return @onReceive yield @$send './save',data
    else
      @showErrors errors
    return false

  onReceive : ({status,errs,err})=>
    if err?
      errs?={}
      errs['other'] = err
    return true if status=='success'
#      for cl in @subjects
#        cl.resetError()

    if not errs.correct
      @showErrors errs
    return false
