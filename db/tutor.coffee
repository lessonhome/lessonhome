
####
# Данные которые относятся только к репетиторам
####


tutor:
  person      : "asdfadsf"       # persons.id
  registration_progress : 3     # текущий шаг регистрации
                  # use function new Date(year,month,day) to get it
  status      : 'graduate'  # статус преподавателя
    # schoolboy школьник
    # student   студент
    # graduate  аспирант/выпускник
    # phd       кандидат наук
    # phd2      доктор наук

  
  experience  : '6 лет' #опыт репетиторства 
  extra : [
    {
      type  : 'text'
      text  : "Победитель олимпиады по физике"
    }
    {
      type  : "image"
      text  : "Победитель олимпиады по инворматике"
      file  : 'hash2213421432134'
    }
    {
      type  : "video"
      text  : "Мои методы преподавания"
      file  : "hashdsafasdf3241"
    }
  ]
  reason    : 'Нравится передавать опыт другим людям, люблю людей'        # почему я репетитор
  about: 'Довожу учеников до полного успеха, индивидуальный подход к каждому'#осебекакрепетиторе
  slogan    : 'никогда не сдавайся' #девиз ??? WAT?
  orders    : [
    {
      id : "21342143" # id заявки
      #{data} : ----  # какие-то данные для этой заявки TODO
    }
  ]
  notifications : [
    email : [
      "tema2@mail.ru"
    ]
    phone : [
      "9150527355"
    ]
  ]
  phone_call :
    phones      : [ "9150527355" ]
    description : "желательно с 19 до 21 часа"
  subjects : [
    {
      name        : 'математика'
      description : 'подготовка к ЕГЭ, старшие классы; 3,4 классы; студенты'
      tags        : ['ЕГЭ','ГИА','ОГЭ','school:high','school:3','school:4', 'students']
      price :
        range   : [1000,1500] # одно значение если не диапазон а фиксированная цена
        duration: "90"        # продолжительность в минутах 
                              # либо lesson, если цена за занятие а не по вермени
        description : "За дорогу к ученику доплачивать 300р"  # коментарий к цене
      place : ['tutor','pupil','other'] # или одно из; other - где-то в другом месте
      other_places : [
        {
          title       : "Библиотека"
          description : "В молодежной библиотеке на Преображенке. Отличное место!"
        }
      ]
      groups : [
        {
          price:
            range : []
            duration : ""
          description : ""
          places : [
            {
              title       : ""
              description : ""
            }
          ]
        }
      ]
    }
  ]
  calendar: [
    {
      day: 'пн' #день недели
      period:
        start : '12:00' #время с 
        end   : '16:00' #время до 
      title : "Ем!"
      description : "Да! Я ем! Преподавателям тоже иногда нужно есть!"
    }
  ]
  #pref_gender: 'man' #предпочтения пол        TODO Не понимаю зачем это нужно
  #pref_status: 'студент' #предпочтения статус TODO 



    
