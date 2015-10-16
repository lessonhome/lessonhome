
class @main extends @template '../main'
  route : '/tutor_profile'
  model : 'main/eyed_student_profile'
  title : "Профиль репетитора"
  access : ['other','pupil']
  tree : =>
    clear_profile : true

###    
    content : @module '$' :
      rating_photo  : @state './preview/all_rating_photo':
        image         : @exports()
        count_review  : @exports()
        close         : false
        extract       : 'extract'
        rating        : @exports()
        rev_selector  : 'no_reviews'
      hidden_subject : @module '$/subject'
      rating: @module 'rating_star'
      value: {
        tutor_name: $form : person : 'dativeName.first'
        location: 'г.Москва, р.Одинцово, м.Одинцово'
        full_name: 'Иванов Иван Иванович'
        description: 'Репетитор по англискому и испанскому, подготовлю к вступительным ИСАА'
        status: 'Преподаватель школы'
        experience: '3 года'
        age: '45 лет'
        work_place: 'ИСАА, ассистент'
        education: 'МХАТ, ВГИК, Российская академия музыки им.Гнесиных'
        areas_departure: 'р.Зеленоград, м.Беляево, р.Беляево, м.Сходненская, р.Солнцегорск'
        about_text: 'Отбор будет очень быстрым и пройдет в ОЧНОМ режиме. Уже ЗАВТРА, 5 АВГУСТА, вы решите короткий, но довольно сложный кейс и, в случае успеха, получите приглашение на открытие второй волны. Времени на все осталось очень мало, а потому нужно успеть пройти регистрацию до 12:00 завтрашнего дня (5 августа). '
        #honors_text: 'Отбор будет очень быстрым и пройдет в ОЧНОМ режиме. Уже ЗАВТРА, 5 АВГУСТА, вы решите короткий, но довольно сложный кейс и, в случае успеха, получите приглашение на открытие второй волны. Времени на все осталось очень мало, а потому нужно успеть пройти регистрацию до 12:00 завтрашнего дня (5 августа). '
        subjects : [
          @module '$/subject' :
            subject: 'Английский язык'
            training_direction: ['ЕГЭ', 'ИСА', 'разговорный', 'грамматика']
            comment: 'очень важный комментарий'
        ]
      }
      attach_button     : @module 'tutor/checkbox_button' :
        checkbox        : @module 'tutor/forms/checkbox' :
          value : false
          selector: 'small'
        selector  : 'attach'
        text      : 'прикрепить к заявке'
      msg: @module 'tutor/forms/textarea' :
        height    : '117px'
        text      : 'Сообщение :'
        selector  : 'write_tutor'
      name: @module 'tutor/forms/input'  :
        text1        : 'Ваше имя :'
        selector  : 'write_tutor'
      phone: @module 'tutor/forms/input'  :
        text1        : 'Ваш телефон :'
        selector  : 'write_tutor'
      subject: @module 'tutor/forms/drop_down_list' :
        text      : 'Выберите предмет :'
        selector  : 'write_tutor'
        smart : false
        self : false
        no_input : true
        default_options     : {
          '0': {value: 'english', text: 'английский язык'}
          '1': {value: 'math', text: 'математика'}
          '2': {value: 'russian_language', text: 'русский язык'}
          '3': {value: 'music', text: 'музыка'}
          '4': {value: 'physics', text: 'физика'}
          '5': {value: 'chemistry', text: 'химия'}
          '6': {value: 'german', text: 'немецкий язык'}
          '7': {value: 'primary_school', text: 'начальная школа'}
          '8': {value: 'french', text: 'французский язык'}
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
          '31': {value: 'chinese', text: 'китайский язык'}
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
      agree_checkbox: @module 'tutor/forms/checkbox' :
        value : true
        selector: 'small'
      write_button: @module 'link_button' :
        selector: 'write_tutor'
        text: 'Написать' #TODO: insert a real name of tutor
###
