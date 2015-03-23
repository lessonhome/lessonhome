

class @main extends template './motivation_content'
  route : '/first_step'
  model   : 'main/first_step'
  title : "выберите предмет"
  tags  : -> 'pupil:main_search'
  tree : =>
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : state './filter_top' :
      title         : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list' :
        selector    : 'filter_top'
        placeholder : 'Предмет'
        default_options     : {
          '0': {value: 'english', text: 'английский язык'},
          '1': {value: 'math', text: 'математика'},
          '2': {value: 'russian_language', text: 'русский язык'},
          '3': {value: 'music', text: 'музыка'},
          '4': {value: 'physics', text: 'физика'},
          '5': {value: 'chemistry', text: 'химия'},
          '6': {value: 'german', text: 'немецкий язык'},
          '7': {value: 'primary_school', text: 'начальная школа'}
          '8': {value: 'french', text: 'франзузский язык'}
          '9': {value: 'social_studies', text: 'обществознание'}
          '10': {value: 'computer_science', text: 'информатика'}
          '11': {value: 'programming', text: 'программирование'}
          '12': {value: 'spanish', text: 'испанский язык'}
          '13': {value: 'biology', text: 'биология'}
          '14': {value: 'speech_therapists', text: 'логопеды'}
          '15': {value: 'acting_skills', text: 'актёрское мастерство'}
          '16': {value: 'algebra', text: 'алгебра'}
          '17': {value: 'arabic', text: 'арабский язык'}
          '18': {value: 'accounting', text: 'бухгалтерский учёт'}
          '19': {value: 'hungarian', text: 'венгерский язык'}
          '20': {value: 'vocals', text: 'вокал'}
          '21': {value: 'higher_mathematics', text: 'высшая математика'}
          '22': {value: 'geography', text: 'география'}
          '23': {value: 'geometry', text: 'геометрия'}
          '24': {value: 'guitar', text: 'гитара'}
          '25': {value: 'dutch', text: 'голландский язык'}
          '26': {value: 'greek', text: 'греческий язык'}
          '27': {value: 'danish', text: 'датский язык'}
          '28': {value: 'hebrew', text: 'иврит'}
          '29': {value: 'history', text: 'история'}
          '30': {value: 'italian', text: 'итальянский язык'}
          '31': {value: 'chinese', text: 'китайския язык'}
          '32': {value: 'computer_graphics', text: 'компьютерная графика'}
          '33': {value: 'korean', text: 'корейский язык'}
          '34': {value: '', text: ''}
          '35': {value: '', text: ''}
          '36': {value: '', text: ''}
          '37': {value: '', text: ''}
          '38': {value: '', text: ''}
          '39': {value: '', text: ''}
          '40': {value: '', text: ''}
          '41': {value: '', text: ''}
          '42': {value: '', text: ''}
          '43': {value: '', text: ''}
          '44': {value: '', text: ''}
          '45': {value: '', text: ''}
          '46': {value: '', text: ''}
          '47': {value: '', text: ''}
          '48': {value: '', text: ''}
          '49': {value: '', text: ''}
          '50': {value: '', text: ''}
          '51': {value: '', text: ''}
          '52': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}
          '': {value: '', text: ''}


        }
      choose_subject  : module '../selected_tag'  :
        selector  : 'choose_subject'
        id        : '123'
        text      : 'Алгебра'
        close     : true
      empty_choose_subject : module '../selected_tag' :
        selector  : 'choose_subject'
        id        : ''
        text      : ''
        close     : true
      link_forward    :  '/second_step'


    info_panel  : state './info_panel'  :
      math : module '//item' :
        title: 'Математические +'
        list : [
          'Математика 1'
          'Математика 2'
          'Математика 3'
          'Математика 4'
          'Математика 5'
          'Математика 6'
        ]
      natural_research  : module '//item' :
        title : 'Естественно-научные +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      philology         : module '//item' :
        title : 'Филологичные +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      foreign_languages : module '//item' :
        title : 'Иностранные языки +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      others            : module '//item' :
        title :'Другие +'
        list : [
          'Предмет 1'
          'Предмет 2'
          'Предмет 3'
          'Предмет 4'
          'Предмет 5'
          'Предмет 6'
        ]
      selector : 'first_step'
