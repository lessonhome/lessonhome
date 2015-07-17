class @main extends @template '../../tutor'
  route : '/tutor/search_bids'
  model   : 'tutor/bids/search_bids'
  title : "поиск заявок"
  tags   : -> 'tutor:search_bids'
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    items : [
      @module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
        tag   : 'tutor:search_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
      @module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
      ]
    content : @module '$' :
      advanced_filter : @exports()
      min_height      : @exports()
      subject : @module 'tutor/forms/drop_down_list' :
        selector  : 'search_bids fast_bid'
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
      course : @state '../forms/drop_down_list_with_tags' :
        list: @module 'tutor/forms/drop_down_list:type1'  :
          selector        : 'advanced_filter_form'
          placeholder     : 'Например ЕГЭ'
          value     : ''
        tags: ''
      price: @state '../../main/slider_main' :
        selector      : 'advanced_filter_price'
        default :
          left : 500
          right : 3500
        min : 500
        max : 3500
        type : 'default'
        dash          : '-'
        measurement   : 'руб./60 мин.'
        division_value : 50
      saved_filters : @module 'tutor/forms/drop_down_list' :
        selector  : 'search_bids fast_bid'
      saved_filters_button: @module 'tutor/button' :
        selector: 'saved_filters_button'
        text: 'Сохранить'

      cancel_button: @module 'tutor/button' :
        selector: 'filters_cancel'
        text: 'ОТМЕНА'
      apply_filters_button: @module 'tutor/button' :
        selector: 'apply_filters'
        text: 'ПРИМЕНИТЬ ФИЛЬТРЫ'
      calendar        : @module 'new_calendar' :
        selector    : 'bids'

      pre_school      : @module 'tutor/forms/checkbox' :
        text      : 'Дошкольник'
        selector  : 'small font_16'
      junior_school   : @module 'tutor/forms/checkbox' :
        selector  : 'small font_16'
        text      : 'Младшая школа'
      medium_school   : @module 'tutor/forms/checkbox' :
        selector  : 'small font_16'
        text      : 'Средняя школа'
      high_school     : @module 'tutor/forms/checkbox' :
        selector  : 'small font_16'
        text      : 'Старшая школа'
      student_categories: @module 'tutor/forms/checkbox' :
        selector  : 'small font_16'
        text      : 'Студент'
      adult           : @module 'tutor/forms/checkbox' :
        selector  : 'small font_16'
        text      : 'Взрослый'


      place_tutor      : @module 'tutor/forms/checkbox' :
        text      : 'у себя'
        selector  : 'small font_16'
      place_pupil      : @module 'tutor/forms/checkbox' :
        text      : 'у ученика'
        selector  : 'small font_16'
      place_remote      : @module 'tutor/forms/checkbox' :
        text      : 'удалённо'
        selector  : 'small font_16'
      place_cafe      : @module 'tutor/forms/checkbox' :
        text      : 'другое место'
        selector  : 'small font_16'

      area: @state '../forms/drop_down_list_with_tags' :
        list: @module 'tutor/forms/drop_down_list:type1'  :
          selector        : 'advanced_filter_form'
          placeholder     : 'Например Выхино'
          value     : ''
        tags: ''

      road_time_15  : @module 'tutor/forms/checkbox' :
        text      : '~15 мин.'
        selector  : 'small font_16'
      road_time_30  : @module 'tutor/forms/checkbox' :
        text      : 'до 30 мин.'
        selector  : 'small font_16'
      road_time_45  : @module 'tutor/forms/checkbox' :
        text      : 'до 45 мин.'
        selector  : 'small font_16'
      road_time_60  : @module 'tutor/forms/checkbox' :
        text      : 'до 60 мин.'
        selector  : 'small font_16'
      road_time_90  : @module 'tutor/forms/checkbox' :
        text      : 'до 90 мин.'
        selector  : 'small font_16'
      road_time_120  : @module 'tutor/forms/checkbox' :
        text      : 'до 120 мин.'
        selector  : 'small font_16'

      choose_gender   : @state 'gender_data':
        selector        : 'advanced_filter'
        selector_button : 'advance_filter'
        default   : 'male'

      ###
        tutor : @module 'tutor/forms/location_button' :
          selector : 'place_learn'
          text   : 'у себя'
        student  : @module 'tutor/forms/location_button' :
          selector : 'place_learn'
          text   : 'у ученика'
        web : @module 'tutor/forms/location_button' :
          selector : 'place_learn'
          text   : 'удалённо'
        #location_hint : @module 'tutor/hint' :
        #  selector : 'small'
        #  field_position : 'left'
        #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
        address_list : @module 'tutor/forms/drop_down_list' :
          selector  : 'search_bids fast_bid'
          text      : 'Ваш адрес :'
        save_button  : @module 'tutor/button' :
          text     : 'Сохранить'
          selector : 'search_bids_save'
        road_time_slider : @state 'main/slider_main' :
          selector      : 'road_time_search_bids'
          #start         : 'road_time_search_bids'
          default :
            left : 15
            right : 180
          dash          : 'до'
          measurement   : 'мин.'
          #handle        : false
          min            : 15
          max            : 180
          left           : 30
          right          : 120
          division_value : 10
        separate_line : @module 'tutor/separate_line' :
          selector : 'horizon'

      ###
      list_bids : @module 'tutor/bids/list_bids' :
        titles_bid : @module '//titles_bid' :
          indent     : false
          number_date   : 'Номер/Дата'
          subject_level : 'Предмет/Уровень'
          place         :'Место'
          city_district : 'Город/Район'
          bet           : 'Ставка'
          price         : 'Цена'
        all_bids : [
          @module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          @module '//bid' :
            selectable   : false
            number    : 15723
            date      : "20 декабря"
            subject   : 'Математика'
            level     : '8 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Выхино'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          @module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          @module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          @module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
        ]
      courses_list : @module 'tutor/forms/drop_down_list'
  init : ->
    @parent.tree.left_menu.setActive 'Заявки'
