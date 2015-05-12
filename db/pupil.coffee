
####
# Данные которые относятся только к ученикам
####

pupil :
  person       : "hash32141234" # persons.id
  fast_bid_progress : 2 # текущий шаг подачи заявки  
  status : "student" # статус ученика
    # preschooler дошкольник
    # junior school младшая школа 
    # secondary school средняя школа 
    # high school старшая школа 
    # student студент 
    # adult взрослый 

  phone_call :
    phones      : [ "9150527355" ]
    description : "желательно с 19 до 21 часа" 
  subjects : [
    {
      subject      : "математика" # предмет
      comments     : "срочно" # комментарий 
      course       : "ОГЭ" #
      knowledge    : "начинающий" # уровень знаний 
      lesson_price : "1000" # цена одного занятия 
      goal         : "подтянуть школьную программу" # цель ученика 
      place        : ['tutor','pupil','other'] # или одно из; other - где-то в другом мест  
      road_time   : "60" # время на дорогу  
      calendar: [
        {
          day: 'пн' #день недели
          period:
            start : '12:00' #время с 
            end   : '16:00' #время до 
          comment : "" # комментарий
        }
      ]
      lesson_duration : "90 мин." # продолжительность одного занятия 
      requirements_for_tutor: # требования к репетитору 
        status : "school_teacher" # статус
	  # student Студент
	  # school_teacher Преподаватель школы
	  # high_school_teacher Преподаватель ВУЗа
          # native_speaker Носитель языка
        experience : "больше 5 лет" # опыт преподавания 
        sex : "female" # пол 
	age : [20, 45] # возраст 
        with_reviews : "true" # с отзывами 
        verified : "true" # верефицированные 

    }
  ]



