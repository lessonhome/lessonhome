class @main
  forms : [{'tutor':['all_subjects']}]
  tree : => @module '$' :
    data : $form : tutor : 'all_subjects'
#    subject : @state './subject_tutor_test'
    test : @module 'tutor/forms/adds_blocks' :
      element : @module 'tutor/forms/adds_blocks/element' :
        key_title : 'name'
        title_element : @module 'tutor/forms/drop_down_list' :
          placeholder: 'Выберите предмет'
          selector  : 'third_reg'
          $form : tutor : 'all_subjects.0.name'
          self  : true
          smart : true
        content_form: @module 'subjects_tutor_test/form' :
          course     : @module 'tutor/forms/drop_down_list_with_tags' :
            list     : @module 'tutor/forms/drop_down_list' :
              placeholder : 'Например ЕГЭ'
              smart : true
              self : true
              selector  : 'third_reg'
            tags : $form : tutor : 'all_subjects.0.course'
          pre_school      : @module 'tutor/forms/checkbox' :
            text      : 'дошкольники'
            selector  : 'small font_16'
            value : $form : tutor : 'all_subjects.0.pre_school'
          junior_school   : @module 'tutor/forms/checkbox' :
            selector  : 'small font_16'
            text      : 'младшая школа'
            value : $form : tutor : 'all_subjects.0.junior_school'
          medium_school   : @module 'tutor/forms/checkbox' :
            selector  : 'small font_16'
            text      : 'средняя школа'
            value : $form : tutor : 'all_subjects.0.medium_school'
          high_school     : @module 'tutor/forms/checkbox' :
            selector  : 'small font_16'
            text      : 'старшая школа'
            value : $form : tutor : 'all_subjects.0.high_school'
          student         : @module 'tutor/forms/checkbox' :
            selector  : 'small font_16'
            text      : 'студент'
            value : $form : tutor : 'all_subjects.0.student'
          adult           : @module 'tutor/forms/checkbox' :
            selector  : 'small font_16'
            text      : 'взрослый'
            value : $form : tutor : 'all_subjects.0.adult'
          place_tutor    : @state 'tutor/forms/checkbox_hide_block' :
            is_show : $form : tutor : 'all_subjects.0.place_tutor.selected'
            title : 'у себя'
            selector: 'col2'
            content : @state 'tutor/time_price' :
              currency : 'руб.'
              one_hour : $form : tutor : 'all_subjects.0.place_tutor.one_hour'
              two_hour : $form : tutor : 'all_subjects.0.place_tutor.two_hour'
              tree_hour : $form : tutor : 'all_subjects.0.place_tutor.tree_hour'
          place_pupil    : @state 'tutor/forms/checkbox_hide_block' :
            is_show : $form : tutor : 'all_subjects.0.place_pupil.selected'
            title : 'у ученика'
            selector: 'col2'
            content : @state 'tutor/time_price' :
              currency : 'руб.'
              one_hour : $form : tutor : 'all_subjects.0.place_pupil.one_hour'
              two_hour : $form : tutor : 'all_subjects.0.place_pupil.two_hour'
              tree_hour : $form : tutor : 'all_subjects.0.place_pupil.tree_hour'
          place_remote   : @state 'tutor/forms/checkbox_hide_block' :
            is_show : $form : tutor : 'all_subjects.0.place_remote.selected'
            title : 'удаленно'
            selector: 'col2'
            content : @state 'tutor/time_price' :
              currency : 'руб.'
              one_hour : $form : tutor : 'all_subjects.0.place_remote.one_hour'
              two_hour : $form : tutor : 'all_subjects.0.place_remote.two_hour'
              tree_hour : $form : tutor : 'all_subjects.0.place_remote.tree_hour'
          group_learning : @state 'tutor/forms/checkbox_hide_block' :
            is_show : $form : tutor : 'all_subjects.0.group_learning.selected'
            title : 'групповые'
            content : @module 'tutor/group_price' :
              price : @module 'tutor/forms/input' :
                replace : [
                  "[^\\d]"
                  "(\\d\\d\\d\\d)(.+)":"$1"
                ]
                value : $form : tutor : 'all_subjects.0.group_learning.price'
                selector   : 'fast_bid'
              group_people : @module 'tutor/forms/drop_down_list' :
                placeholder : 'Численность группы'
                selector  : 'first_reg1'
                self      : false
                value : $form : tutor : 'all_subjects.0.group_learning.groups'
                default_options     : {
                  '1': {value: '1', text: '2-4 ученика'},
                  '2': {value: '2', text: 'до 8 учеников'},
                  '3': {value: '3', text: 'от 10 учеников'}
                }
          comments        : @module 'tutor/forms/textarea' :
            height    : '100px'
            selector  : 'third_reg'
            value : $form : tutor : 'all_subjects.0.comments'
      add_button : @module 'link_button' :
        selector : 'big_yellow_button'
        text : '+ Добавить ещё предмет'

    default_subjects : {
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
#      '41': {value: 'descriptive_geometry', text: 'начертательная геометрия'}
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
      '53': {value: 'violin', text: 'скрипка'}
      '54': {value: 'sol-fa', text: 'сольфеджио'}
#      '55': {value: 'strength_of_materials', text: 'сопротивление материалов'}
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

