class @main
  tree : => @module '$' :
# data
    math              : @exports()
    natural_research  : @exports()
    philology         : @exports()
    foreign_languages : @exports()
    others            : @exports()

    advanced_search   : @exports()
    subject           : @exports()
    tutor             : @exports()
    place             : @exports()
    price             : @exports()
    selector          : @exports()

# style
    selector          : @exports()



    math : @module '//item' :
      title: 'Математические +'
      list : [
        'Математика'
        'Алгебра'
        'Геометрия'
        'Информатика'
        'Черчение'
      ]
    natural_research  : @module '//item' :
      title : 'Естественно-научные +'
      list : [
        'Биология'
        'География'
        'История'
        'Биология'
        'Физика'
        'Химия'
        'Естествознание'
        'Экология'
        'Философия'
      ]
    philology         : @module '//item' :
      title : 'Филологические +'
      list : [
        'Русский язык'
        'Литература'
      ]
    foreign_languages : @module '//item' :
      title : 'Иностранные языки +'
      list : [
        'Английский язык'
        'Испанский язык'
        'Французский язык'
        'Итальянский'
        'Иврит'
      ]
    others            : @module '//item' :
      title :'Другие +'
      list : [
        'Актерское мастерство'
        'Логопеды'
        'Музыка'
        'Начальная школа'
        'Подготовка к школе'
        'Экономика'
        'Компьютерные курсы'
      ]
      selector  : 'others'
    selector : 'first_step'
