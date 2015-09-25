
class @main
  tree : => @module '$' :
    select_subject_field : @module 'tutor/forms/drop_down_list' :
      placeholder : 'Выберите предмет'
      selector  : 'first_reg1'
      smart : true
      self : true
      default_options     : {
        '0': {value: 'english', text: 'английский язык'}
        '1': {value: 'math', text: 'математика'}
        '2': {value: 'russian_language', text: 'русский язык'}
        '3': {value: 'music', text: 'музыка'}
        '4': {value: 'physics', text: 'физика'}
        '5': {value: 'chemistry', text: 'химия'}
        '6': {value: 'german', text: 'немецкий язык'}
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
#      value : $form : tutor : subjects : (s)->
#        a = s?[0]?.name
#        return a?=""
    course     : @module 'tutor/forms/drop_down_list_with_tags' :
      list     : @module 'tutor/forms/drop_down_list' :
        placeholder : 'Например ЕГЭ'
        smart : true
        self : true
        selector  : 'first_reg'
#        items : ['JLPT', 'JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5', 'TOPIK', 'TOPIK I', 'TOPIK II', 'HSK', 'HSK Высший', 'HSK Начальный/средний', 'HSK Базовый', 'DELE', 'DELE A', 'DELE B', 'DELE C', 'TOEFL','IELTS', 'FCE', 'TOEIC', 'Business English', 'GMAT', 'GRE', 'SAT', 'DELF', 'DELF A', 'DELF B', 'DALF ', 'DSH', 'TestDaF', 'CILS', 'CILS B1', 'CILS B2', 'CILS C1', 'CILS C2', 'CEPRE-Bras', 'CEPRE-Bras Средний', 'CEPRE-Bras Выше среднейго', 'CEPRE-Bras Продвинутый', 'CEPRE-Bras Выше продвинутого', 'ЕГЭ', 'ОГЭ (ГИА)', 'Разговорный', 'Бизнес', 'С нуля']
    pre_school      : @module 'tutor/forms/checkbox' :
      text      : 'дошкольники'
      selector  : 'small font_16'
    junior_school   : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'младшая школа'
    medium_school   : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'средняя школа'
    high_school     : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'старшая школа'
    student         : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'студент'
    adult           : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'взрослый'
    place_tutor    : @state 'tutor/forms/checkbox_hide_block' :
      title : 'у себя'
      selector: 'col2'
      content : @state 'tutor/time_price' :
        currency : 'руб.'
    place_pupil    : @state 'tutor/forms/checkbox_hide_block' :
      title : 'у ученика'
      selector: 'col2'
      content : @state 'tutor/time_price' :
        currency : 'руб.'
    place_remote   : @state 'tutor/forms/checkbox_hide_block' :
      title : 'удаленно'
      selector: 'col2'
      content : @state 'tutor/time_price' :
        currency : 'руб.'
    group_learning : @state 'tutor/forms/checkbox_hide_block' :
      title : 'групповые'
      content : @module 'tutor/group_price' :
        price : @module 'tutor/forms/input' :
          replace : [
            "[^\\d]"
          ]
          value : '0'
          selector   : 'fast_bid'
        group_people : @module 'tutor/forms/drop_down_list' :
          placeholder : 'Численность группы'
          selector  : 'first_reg1'
          self      : false
          default_options     : {
#            '0': {value: '0', text: 'не проводятся'},
            '1': {value: '1', text: '2-4 ученика'},
            '2': {value: '2', text: 'до 8 учеников'},
            '3': {value: '3', text: 'от 10 учеников'}
          }

#    place_tutor           : @state 'tutor/full_price' :
#      text  : 'у себя'
#      value : {
#        one_hour : '1000',
#        two_hour : '200'
#        three_hour : '80000'
#      }
#    place_pupil           : @state 'tutor/full_price' :
#      text  : 'у ученика'
#    place_remote          : @state 'tutor/full_price' :
#      text  : 'удаленно'
#    group_learning         : @module 'tutor/full_price/group' :
#      chose_group      : @module 'tutor/forms/checkbox' :
#        text      : 'групповые'
#        selector  : 'small font_16'
#      #$form : tutor : 'isPlace.tutor'
#      price : @module 'tutor/forms/input' :
#        selector  : 'fast_bid'
#      group_people         : @module 'tutor/forms/drop_down_list' :
#        selector  : 'first_reg1'
#        self      : true
#        default_options     : {
#          '0': {value: '0', text: 'не проводятся'},
#          '1': {value: '1', text: '2-4 ученика'},
#          '2': {value: '2', text: 'до 8 учеников'},
#          '3': {value: '3', text: 'от 10 учеников'}
#        }
#        $form : tutor : 'subject.groups.0.description' : (val)-> val || 'не проводятся'
#
#
#      selector  : 'first_reg'
#      self      : true
#      default_options     : {
#        '0': {value: '0', text: 'не проводятся'},
#        '1': {value: '1', text: '2-4 ученика'},
#        '2': {value: '2', text: 'до 8 учеников'},
#        '3': {value: '3', text: 'от 10 учеников'}
#      }
    comments        : @module 'tutor/forms/textarea' :
      height    : '100px'
      selector  : 'first_reg1'
      value : @exports 'subject.description'