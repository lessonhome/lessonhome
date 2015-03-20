
class @main
  tree : -> module '$' :
    subject                : module 'tutor/forms/drop_down_list' :
      text      : 'Предмет :'
      selector  : 'first_reg'
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
        '34': {value: 'latin', text: 'латынь'}
        '35': {value: 'literature', text: 'литература'}
        '36': {value: 'logic', text: 'логика'}
        '37': {value: 'macroeconomics', text: 'макроэкономика'}
        '38': {value: 'mathematical_analysis', text: 'математический анализ'}
        '39': {value: 'management', text: 'менеджмент'}
        '40': {value: 'microeconomics', text: 'микроэкономика'}
        '41': {value: 'descriptive_geometry', text: 'начертательная геометрия'}
        '42': {value: 'norwegian', text: 'норвежский язык'}
        '43': {value: 'origami', text: 'оригами'}
        '44': {value: 'preparing_for_school', text: 'подготовка к школе'}
        '45': {value: 'polish', text: 'польский язык'}
        '46': {value: 'portuguese', text: 'португальский язык'}
        '47': {value: 'jurisprudence', text: 'правоведение'}
        '48': {value: 'psychology', text: 'психология'}
        '49': {value: 'drawing', text: 'рисование'}
        '50': {value: 'rhetoric', text: 'риторика'}
        '51': {value: 'rct', text: 'рки'}
        '52': {value: 'serbian', text: 'сербский язык'}
        '53': {value: 'violin', text: 'скрипка1'}
        '54': {value: 'sol-fa', text: 'сольфеджио'}
        '55': {value: 'strength_of_materials', text: 'сопротивление материалов'}
        '56': {value: 'statistics', text: 'статистика'}
        '57': {value: 'theoretical_mechanics', text: 'теоретическая механика'}
        '58': {value: 'probability_theory', text: 'теория вероятностей'}
        '59': {value: 'turkish', text: 'турецкий язык'}
        '60': {value: 'philosophy', text: 'философия'}
        '61': {value: 'finnish', text: 'финский язык'}
        '62': {value: 'flute', text: 'флейта'}
        '63': {value: 'piano', text: 'фортепиано'}
        '64': {value: 'hindi', text: 'хинди'}
        '65': {value: 'drawing', text: 'черчение'}
        '66': {value: 'czech', text: 'чешский язык'}
        '67': {value: 'chess', text: 'шахматы'}
        '68': {value: 'swedish', text: 'шведский язык'}
        '69': {value: 'econometrics', text: 'эконометрика'}
        '70': {value: 'economy', text: 'экономика'}
        '71': {value: 'electrical_engineering', text: 'электротехника'}
        '72': {value: 'japanese', text: 'японский язык'}


      }
    list_course             : module 'tutor/forms/drop_down_list' :
      text      : 'Курс :'
      selector  : 'first_reg'
    categories_of_students : module 'tutor/forms/drop_down_list' :
      text      : 'Категория ученика :'
      selector  : 'first_reg'
      default_options     : {
        '0': {value: 'preschool_child', text: 'дошкольник'},
        '1': {value: 'student_junior_school', text: 'школьник - младшая школа'},
        '2': {value: 'student_high_school', text: 'школьник - средняя школа'},
        '3': {value: 'student_senior_school', text: 'школьник - старшая школа'},
        '4': {value: 'student', text: 'студент'},
        '5': {value: 'grown_up', text: 'взрослый'}
      }
    place                  : module 'tutor/forms/drop_down_list' :
      text      : 'Место :'
      selector  : 'first_reg place'
    price                  : module 'tutor/forms/input' :
      text      : 'Цена :'
      selector  : 'price_reg'
    price_button           : module 'button_add' :
      text      : '+'
      selector  : 'plus'
    students_in_group       : module 'tutor/forms/drop_down_list' :
      text      : 'Групповые занятия :'
      selector  : 'first_reg group'
    group_lessons_bet       : module 'tutor/forms/drop_down_list' :
      placeholder : 'Ставка'
      selector    : 'first_reg bet'
    comments                : module 'tutor/forms/textarea' :
      height    : '80px'
      text      : 'Комментарии :'
      selector  : 'first_reg'
    add_button              : module 'tutor/button' :
      text     : '+Добавить'
      selector : 'reg_add'












