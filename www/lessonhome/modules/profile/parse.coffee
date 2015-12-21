PLACE_TITLES = [
  ['tutor', 'У себя']
  ['pupil' , 'Выезд']
  ['remote' , 'Skype']
]


TIMES = [
  ['v60', 60],
  ['v90', 90],
  ['v120', 120]
]


STATUS_VALUES = {
  student: "Студент"
  private_teacher: "Частный преподаватель"
  university_teacher: "Преподаватель ВУЗа"
  school_teacher: "Преподаватель школы"
}

@parse = (data) =>
  data ?= {}

  SetNewFormatPrice data

  value = {
    full_name : "#{data.name?.first || ''} #{data.name?.middle || ''}"
    dative_name : DativeName(data.name).first || ''
    slogan : data.slogan if data.slogan?
    src_avatar : null
    age : null
    location : null
    status : null
    places : []
    show_places : false
    sub : null
    short_price : []
    subjects : []
    education : []
    about : data['about']
    why : data['reason']
    index : data.index
    interests : Join data['interests'], 'description'
    reviews : []
    documents : []
  }
  if data.photos?
    continue for key, photo of data.photos
    value.src_avatar = {
      lurl : photo.lurl
      hurl : photo.hurl
    }

  if data.age? && data.age
    value.age = data.age
    age_end = data.age%10
    switch age_end
      when 1
       value.age += " год"
      when 2,3,4
        value.age += " года"
      else
        value.age += " лет"

  if data.location?
    l = []
    loc = data.location
    if (str = loc.city)? and (str = Trim str) then l.push('г. ' + str)
    if (str = loc.area)? and (str = Trim str) then l.push('р-н ' + str)
    if loc.metro?
      metro = loc.metro.split(',')
      for str in metro when str = Trim str
        l.push('м. ' + str)

    value.location = l.join(', ') if l.length

  if data.status? and STATUS_VALUES[data.status]? then value.status = STATUS_VALUES[data.status]


  if data.place?
    for place in PLACE_TITLES

      if data.place[place[0]]?
        p = place : place[1]
        l = ''

        switch place[0]
          when 'tutor' then l = value.location
          when 'pupil'
            if data.check_out_the_areas?
              l = Join data.check_out_the_areas

        p['location'] = l
        if l then value.show_places = true
        value.places.push p

  if data.subjects? and data.ordered_subj?

    subjects  = (name for index, name of data.ordered_subj)

    if subjects.length == 1 and (e = subjects[0].split(',')).length > 1
      value.sub = e.map(Trim)
    else
      value.sub = subjects

    subArr = []
    for name in subjects when data.subjects[name]?.place_prices?
      subArr.push(data.subjects[name].place_prices)

    general = GetGeneral subArr

    main = null
    for place in PLACE_TITLES when (price = general[place[0]])?
      _r = {name : null, prices : null}

      switch place[0]
        when 'remote'
          _r.name = place[1]
          _r.prices = '' + GetPriceAtHour(price) + ' руб. в час'
        else
          unless main?
            main = price
          else
            _r.name = place[1]
            if (diff = GetDiff(main, price))?
              continue if diff == 0
              _r.prices = diff + ' руб.'

      _r.prices = ParsePrices(price) unless _r.prices
      value.short_price.push _r

    

    for sub, i in subjects
      _sub = data.subjects[sub]
      _r = {name: sub, prices: [], description: _sub.description, course : Join _sub.course}
      for place in PLACE_TITLES when (price = subArr[i][place[0]])?
        _r.prices.push {name: place[1], prices: ParsePrices(price)}
      value.subjects.push _r

    for index, e of data.education
      console.log JSON.stringify data.education
      start = e.period?.start
      end = e.period?.end

      start = /\d{4}/.exec(start)[0] if start
      end = /\d{4}/.exec(end)[0] if end

      start = (unless end then 'c ' else '') + start if start
      end = (if start then ' - ' else 'до ') + end if end

      city = if e.city then "г. #{e.city}"
      period = "#{start} #{end} г." if start or end
      info = []
      info.push e.faculty if e.faculty
      info.push e.qualification if e.qualification
      info = info.join(', ')
      _r = {name:  e.name || e.university, city, period, info, about: e.comment}
      value.education.push _r
    
    if data.reviews?
      for index, r of data.reviews when r.review
        value.reviews.push {
          mark : r.mark
          subject : Join r.subject
          course : Join r.course
          review : r.review
          name : r.name
          date : r.date
        }

    if data.media?
      exist = {}
      regexp = /^\/file\/(\w+)\//
      for index, m of data.media
        hash = regexp.exec(m.lurl, true)[1]
        unless exist[hash]
          exist[hash] = true
          value.documents.push {
            lurl : m.lurl
            hurl : m.hurl
          }

  return value

Trim = (str) -> str.replace(/^\s+|\s+$/gm, '')
Join = (obj,key,prep = ', ') ->
  l = ''
  for i, val of obj
    l += (if i == '0' then '' else prep) + (if key and val[key]? then val[key] else val)
  return l

DativeName = (data)->
  name = _nameLib.get((data?.last ? ''),(data?.first ? ''),(data?.middle ? ''))
  return {
    first : name.firstName('dative')
    middle: name.middleName('dative')
    last  : name.lastName('dative')
  }

SetNewFormatPrice = (data) ->
    return unless data.subjects?

    places = []
    subject = data.subjects[ Object.keys(data.subjects)[0] ]

    for k in ['tutor', 'pupil', 'remote']
      return if subject.place_prices[k]?
      places.push(k) if data.place?[k]

    return unless places.length

    roundFifty = (val) ->
      val /= 50
      val = Math.round(val)
      val *= 50
      return val

    p1 = subject?.price?.left
    p2 = subject?.price?.right
    t1 = subject?.duration?.left
    t2 = subject?.duration?.right
    delta_t = t2 - t1

    if delta_t != 0 then k = (p2 - p1)/delta_t else k = 14
    if (k > 200 || k < 4) then k = 14

    new_price =
      v60 : roundFifty( k*(60 - t1)  + p1 )
      v90 : roundFifty( k*(90 - t1)  + p1 )
      v120 : roundFifty( k*(120 - t1) + p1 )

    delete new_price['v60'] if new_price['v60'] < 400

    subject.place_prices[k] = new_price for k in places

GetPriceAtHour = (time_prices) =>
  result = 0
  count = 0
  for key in TIMES when time_prices[key[0]]?
    result += time_prices[key[0]]/key[1]
    count++
  return if count == 0
  result *= 60/count

  result /= 50
  result = Math.round result
  result *= 50
  return result


GetGeneral = (priceArr) =>
  result = {}

  for place in PLACE_TITLES
    for time in TIMES
      for prices in priceArr when (price = prices[place[0]]?[time[0]])?
        result[place[0]] ?= {}
        result[place[0]][time[0]] = price
        break

  return result

ParsePrices = (p) ->
  result = []
  for time in TIMES when p[time[0]]?
    result.push [
      '' + time[1] + ' мин.',
      '' + p[time[0]] + ' руб.'
    ]

  return result

GetDiff = (p1, p2) ->
  min_diff = null
  max_diff = null
  for key in TIMES
    return if p1[key[0]]? != p2[key[0]]?
    continue unless p1[key[0]]?
    diff = p2[key[0]] - p1[key[0]]
    min_diff = diff if  not min_diff? or min_diff > diff
    max_diff = diff if not max_diff? or max_diff < diff
  return if max_diff - min_diff > 50
  result = (max_diff + min_diff)/2
  result /= 50
  result = Math.round result
  result *= 50
  result = '+' + result if result > 0
  return result
