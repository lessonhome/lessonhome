
####
# Данные которые относятся к человеку, не важно, репетитор/ученик/левый чувак
####


persons:
  id : "asdfasdf"   # person id
  account     : "asdfasdfasdfasfd" # accounts.id
  first_name  : 'Иван'          #имя
  middle_name : 'Александрович' #отчество
  last_name   : 'Смирнов'       #фамилия
  sex         : 'male|female'   #пол
  birthday    : ISODate("2015-03-25T17:31:14.904Z")
  location    :
    country : 'Россия'
    city    : 'Москва'
    area    : 'Гагаринский'
    street  : 'Ломоносовский проспект'
    house   : 32
    building: 3
    flat    : 29
    metro   : 'Ленинский проспект'
  phone       : [
    '9267865456'
    '4991603350'
  ]
  email       : [
    'tema@mail.ru'
  ]
  social_networks :
    skype : [
      "tema"
    ]
  site        : [
    "smirnov.ru"
  ]
  education : [   # где учился
    {
      country       : "Россия"
      city          : "Киров"
      type          : "high_school" # or school or colledge
      name          : "Политехничский Университет"
      faculty       : "Экономический"
      chair         : "Нечеткой математики" # кафедра
      qualification : "Магистр"
      description   : "Охуенный универ" # собственно описание места, или какой-то коммент
      period        :    # период обучения
        start : 1997
        end   : 2004
    }
  ]
  work  : [     # где работал, в том числе и сейчас(тогда period.end не определена)
    {
      name        : "ОАО Яндекс"
      post        : "Главный python программист" # описание должности
      #description : "Тестирую какие-то функции, ничего не понятно, но вроде платят."
      #period      :
      #  start : 2008
      #  end   : 2009
    }
  ]
  about     : "Спокойный, тихий, вежливый. Даю другим доминировать надо мной."
  interests : [
    {
      title       : "Рыбалка"
      description : "Каждые выходные ездим с друзьями на рыбалку"
      attachments : [
        {
          type  : "image"
          file  : "hash1233214"
        }
      ]
    }
  ]



  
