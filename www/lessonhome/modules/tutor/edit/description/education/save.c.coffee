
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{education:{country:data.country, city:data.city, name:data.university, faculty:data.faculty, chair:data.chair, qualification:data.status }}},{upsert:true}

  return {status:'success'}


###
    country     : @country.getValue()
    city        : @city.getValue()
    university  : @university.getValue()
    faculty     : @faculty.getValue()
    chair       : @chair.getValue()
    status      : @status.getValue()
    day         : @day.getValue()
    month       : @month.getValue()
    year        : @year.getValue()



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



###
