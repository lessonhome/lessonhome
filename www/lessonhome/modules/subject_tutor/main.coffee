
class @main
  show: =>
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
    @subjects = {}
  
    for i,subject of @tree.subjects
      @subjects[i] = {}
      @subjects[i].class = subject.class
      #@subjects[i].subject_tag = subject.subject_tag.class
      @subjects[i].course = subject.course.class
      @subjects[i].group_learning = subject.group_learning.class
      @subjects[i].duration = subject.duration.class
      @subjects[i].price_from = subject.price_slider.start.class
      @subjects[i].price_till = subject.price_slider.end.class
      @subjects[i].comments = subject.comments.class

      @subjects[i].pre_school = subject.pre_school.class
      @subjects[i].junior_school = subject.junior_school.class
      @subjects[i].medium_school = subject.medium_school.class
      @subjects[i].high_school = subject.high_school.class
      @subjects[i].student = subject.student.class
      @subjects[i].adult = subject.adult.class
      @subjects[i].place_tutor = subject.place_tutor.class
      @subjects[i].place_pupil = subject.place_pupil.class
      @subjects[i].place_remote = subject.place_remote.class
      @subjects[i].place_cafe = subject.place_cafe.class
  
    @subject_list = @tree.select_subject_field.class
    @subject_list.on 'end',(name)=>
      console.log 'end',name
      if @training_direction[name]?
        direction = @training_direction[name]
      else
        direction = @training_direction['default']
      console.log direction
      @subjects?[0]?.class?.showName? name, direction
  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then @onReceive
    else
      return false

  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    ###
      i = 0

      for e in errs
        for e_ in e
          @parseError e_, i
        i++
    ###
    if errs?.length
      for e in errs
        if typeof e == 'object'
          _e = Object.keys(e)[0]
          i = e[_e]
        else
          _e = e
          i = null
        @parseError _e, i
    return false


  check_form : =>
    errs = @js.check @getData()
    for i,subject_val of @subjects
      console.log 'omg',subject_val.class.found.subject_tag.text()
      unless subject_val.class.found.subject_tag.text()
        errs.push 'empty_subject':i
      #if !subject_val.course.exists() && subject_val.course.getValue() != 0
      #  errs.push 'bad_course':i
      #if !@qualification.exists() && @qualification.getValue() != 0
      #  errs.push 'bad_qualification'
      if !subject_val.group_learning.exists() && subject_val.group_learning.getValue() != 0
        errs.push 'bad_group_learning':i

    for e in errs
      if typeof e == 'object'
        _e = Object.keys(e)[0]
        i = e[_e]
      else
        _e = e
        i = null
      @parseError _e, i
    return errs.length==0

  getData : =>
    @subjects_val = {}
    for i,subject of @subjects
      @subjects_val[i] = {}
      @subjects_val[i].name = subject.class.found.subject_tag.text()
      #@subjects_val[i].subject_tag = subject.subject_tag.getValue()
      @subjects_val[i].course = subject.course.getValue()
      @subjects_val[i].group_learning = subject.group_learning.getValue()
      @subjects_val[i].duration = subject.duration.getValue()
      @subjects_val[i].price_from = subject.price_from.getValue()
      @subjects_val[i].price_till = subject.price_till.getValue()
      @subjects_val[i].comments = subject.comments.getValue()

      @subjects_val[i].pre_school = subject.pre_school.getValue()
      @subjects_val[i].junior_school = subject.junior_school.getValue()
      @subjects_val[i].medium_school = subject.medium_school.getValue()
      @subjects_val[i].high_school = subject.high_school.getValue()
      @subjects_val[i].student = subject.student.getValue()
      @subjects_val[i].adult = subject.adult.getValue()
      @subjects_val[i].place_tutor = subject.place_tutor.getValue()
      @subjects_val[i].place_pupil = subject.place_pupil.getValue()
      @subjects_val[i].place_remote = subject.place_remote.getValue()
      @subjects_val[i].place_cafe = subject.place_cafe.getValue()
    return {
      subjects_val : @subjects_val
    }
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


  parseError : (err, i)=>
    switch err
      # short
      when "short_duration"
        @subjects[i].duration.showError "Введите время занятия"
      when 'empty_subject'
        console.log 'empty'
        @tree.select_subject_field.class.setErrorDiv @dom.find '>.err>div'
        @tree.select_subject_field.class.showError "Выберите предмет"
      # long
      when "long_duration"
        @subjects[i].duration.showError ""

      #empty
      when "empty_duration"
        @subjects[i].duration.showError ""
      when "empty_course"
        @subjects[i].course.setErrorDiv @out_err_course
        @subjects[i].course.showError "Выберите курс"
      #when "empty_qualification"
      #  @qualification.setErrorDiv @out_err_qualification
      #  @qualification.showError "Выберите квалификацию"
      when "empty_group_learning"
        @subjects[i].group_learning.setErrorDiv @out_err_group_learning
        @subjects[i].group_learning.showError "Выберите групповые занятия"
      when "empty_categories_of_students"
        @subjects[i].pre_school.setErrorDiv @out_err_categories_of_students
        @subjects[i].pre_school.showError "Выберите категории учеников"
      when "empty_place"
        @subjects[i].place_tutor.setErrorDiv @out_err_place
        @subjects[i].place_tutor.showError "Выберите место занятий"

      #correct
      when "bad_course"
        @subjects[i].course.setErrorDiv @out_err_course
        @subjects[i].course.showError "Выберите корректный курс"
      #when "bad_qualification"
      #  @qualification.setErrorDiv @out_err_qualification
      #  @course.showError "Выберите корректную квалификацию"
      when "bad_group_learning"
        @subjects[i].group_learning.setErrorDiv @out_err_course
        @subjects[i].group_learning.showError "Выберите корректный курс"
