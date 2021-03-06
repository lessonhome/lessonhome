

age = (date1,date2)=>
  years = date2.getFullYear() - date1.getFullYear()
  months = years * 12 + date2.getMonth() - date1.getMonth()
  days = date2.getDate() - date1.getDate()
  
  years -= date2.getMonth() < date1.getMonth()
  months -= date2.getDate() < date1.getDate()
  days += if days < 0
      new Date( date2.getFullYear(), date2.getMonth() - 1, 0 ).getDate() + 1
    else 0
  return {years, months, days}



module.exports = (ids)->
  if typeof ids == 'string'
    ids = [ids]
  account = _invoke @dbAccounts .find(id:{$in : ids})   ,'toArray'
  person  = _invoke @dbPersons  .find(account:{$in:ids}),'toArray'
  tutor   = _invoke @dbTutor    .find(account:{$in:ids}),'toArray'
  [account,person,tutor] = yield Q.all [account,person,tutor]
  account[a.id]     = a for a in account
  person[p.account] = p for p in person
  tutor[t.account]  = t for t in tutor
  
  q = []
  for id in ids
    q.push LoadTutor.call @,id,account[id],person[id],tutor[id]
  yield Q.all q

LoadTutor = (id,account={},person={},tutor={})-> do Q.async =>
  unless account.id && account.index>0
    yield _invoke @redis,'hdel','parsedTutors',id
    yield @jobs.signal 'reloadTutor-deleted',id
    return

  obj = {}
  obj.index = account.index
  
  ###
    for account,obj of persons
      t = obj.tutor
      p = obj.person
      obj.rating = JSON.stringify(obj).length*(obj?.person?.ratio ? 1.0)
      obj.nophoto = false
      unless obj.person?.avatar?[0]?
        obj.rating *= 0.5
        obj.nophoto = true
      unless (obj.tutor?.about ? "")?.length>10
        obj.rating *= 0.5
      rmax = Math.max(rmax ? obj.rating,obj.rating)
      rmin = Math.min(rmin ? obj.rating,obj.rating)
      continue if (t?.subjects?[0]?.name || t?.subjects?[1]?.name) && (p?.first_name)
      delete persons[account]
  ###
  t = tutor
  p = person
  obj.login = account.login
  obj.index = account.index
  obj.registerTime = account.registerTime?.getTime?() ? 0
  obj.accessTime = account.accessTime?.getTime?() ? 0
  obj.rating = 1 #o.rating
  obj.check_out_the_areas = t?.check_out_the_areas ? []
  obj.ratio  = p.ratio ? 1.0
  p.yandex ?= {}
  obj.yandex = {}
  obj.yandex.metro = p.yandex.metro ? []
  obj.yandex.areas = p.yandex.areas ? []
  obj.yandex.all_moscow = p.yandex.all_moscow ? []
  
  obj.nophoto = p.avatar?[0]?
  obj.account = account
  obj.landing = p.landing ? false
  obj.onmain = p.onmain ? false
  obj.checked = p.checked ? false
  obj.mcomment = p.mcomment || ''
  obj.filtration = p.filtration ? false
  obj.phone = p.phone
  obj.email = p.email
  obj.name = {}
  obj.name.first = p?.first_name
  obj.slogan = t?.slogan
  obj.interests = p?.interests
  obj.reviews = p?.reviews
  obj.name.last  = p?.last_name
  obj.name.middle = p?.middle_name
  obj.work = p?.work
  obj.about = t?.about || ""
  obj.check_out_the_areas = t?.check_out_the_areas
  obj.subjects = {}
  if p.birthday
    obj.age = age(p.birthday, new Date())?.years
  obj.education = p.education
  obj.gender  = p.sex
  obj.place = {}
  obj.reason = t?.reason
  obj.left_price = null
  obj.right_price = null
  cLeft = (p,time=60,exists=true)->
    return unless p && (p > 0)
    return if obj.left_price && (!exists)
    p *= 60/time
    obj.left_price = p if (obj.left_price > p) || (!obj.left_price)
  cRight = (p,time=60,exists=true)->
    return unless p && (p > 0)
    return if obj.right_price && (!exists)
    p *= 60/time
    obj.right_price = p if (obj.right_price < p) || (!obj.right_price)
  obj.newl = null
  obj.newr = null
  obj.ordered_subj = []
  for ind,val of t?.subjects
    obj.ordered_subj.push val.name
    ns = obj.subjects[val.name] = {}
    ns.description = val.description
    #obj.about = ns.description unless obj.about
    ns.reason = val.reason
    ns.slogan = val.slogan
    ns.tags = val.tags
    ns.course = val.course
    ns.price  = {left: +val.price?.range?[0]}
    ns.price.right = +(val.price?.range?[1] ? ns.price.left)
    ns.duration  = {}
    d = val.price?.duration
    if d?.left?
      d = [d?.left,d?.right]
      d[1] ?= d[0]
    if (typeof d == 'string') && d
      o = d.match(/^\D*(\d*)?\D*(\d*)?/)
      d = []
      d.push o[1] if o[1]?
      d.push (o[2] ? o[1]) if (o[2] ? o[1])?
    unless (+d?[0]) > 1
      d = [60,120]
    unless (+d?[1]) > 1
      d[1] = d[0]+30
    ns.duration = {left:d[0],right:d[1]}
    def = 800
    ns.price?.right = 900*3  unless ns.price?.right > 0
    ns.price?.left  = 600    unless ns.price?.left > 0
    ns.duration?.right = 180 unless ns.duration?.right > 0
    ns.duration?.left  = 90  unless ns.duration?.left > 0
    
    ns.place_prices = {}
    for place, prices of val.place_prices
      ns.place_prices[place] = {}
      ns.place_prices[place]['v60'] = prices[0] if prices[0] isnt ''
      ns.place_prices[place]['v90'] = prices[1] if prices[1] isnt ''
      ns.place_prices[place]['v120'] = prices[2] if prices[2] isnt ''
      cLeft prices[0]
      cLeft prices[1],90,false
      cLeft prices[2],120,false
      cRight prices[0]
      cRight prices[1],90,false
      cRight prices[2],120,false
    l = ns.price?.left*60/ns.duration?.left
    r = ns.price?.right*60/ns.duration?.right
    obj.newl = l if (!obj.newl) || (obj.newl > l)
    obj.newr = r if (!obj.newr) || (obj.newr > r)
    ns.price_per_hour  = 0.5*(r+l)
    obj.price_left  = Math.round(Math.min(obj.price_left ? ns.price?.left,ns.price?.left)/50)*50
    obj.price_right = Math.round(Math.max(obj.price_right ? ns.price?.right, ns.price?.right)/50)*50
    obj.duration_left  = Math.round(Math.min(obj.duration_left ? ns.duration?.left,ns.duration?.left)/15)*15
    obj.duration_right = Math.round(Math.max(obj.duration_right ? ns.duration?.right, ns.duration?.right)/15)*15
    obj.price_per_hour = Math.round(ns.price_per_hour/50)*50
    for key,val of val?.place
      obj.place[val] = true

  cLeft obj.newl,60,false
  cRight obj.newr,60,false
  obj.left_price = Math.round(obj.left_price/50)*50
  obj.right_price = Math.round(obj.right_price/50)*50
  obj.experience = t?.experience
  if !obj.experience || (obj.experience == 'неважно')
    obj.experience = '1-2 года'
  obj.status = t?.status
  obj.media = []
  if p.photos
    for photo in p.photos
      media =  yield _invoke @dbUploaded.find({hash:{$in:[photo+'low', photo+'high']}}),'toArray'
      if media[0]? and media[1]
        obj.media.push {
          lwidth : media[0].width
          lheight : media[0].height
          lurl : media[0].url
          hheight : media[1].height
          hwidth  : media[1].width
          hurl : media[1].url
        }
  obj.photos = []
  if p.avatar
    for ava in p.avatar
      avatar = yield _invoke @dbUploaded.find({hash : {$in : [ava+'low', ava+'high']}}),'toArray'
      if avatar[0]? and avatar[1]?
        obj.photos.push {
          lwidth  : avatar[0].width
          lheight : avatar[0].height
          lurl    : avatar[0].url
          hheight : avatar[1].height
          hwidth : avatar[1].width
          hurl    : avatar[1].url
        }
  unless obj.photos.length
    obj.photos.push {
      lwidth  : 130
      lheight : 163
      lurl    : "/file/f1468c11ce/unknown.photo.gif"
      hheight : 163
      hwidth : 130
      hurl    : "/file/f1468c11ce/unknown.photo.gif"
    }
  obj.location = p.location

  ##### TODO  temp solution
  obj.ratingMax = 1
  obj.ratingNow = 1
  obj.rating = 1
  obj.rmin = 1
  obj.rmax = 1
  #####
  p = obj

  p.sorts = {}
  ss = Object.keys p.subjects ? {}
  ss2 = []
  for s in ss
    s = s.split /[,;\.]/
    for k in s
      k = k.replace /^\s+/,''
      k = k.replace /\s+$/,''
      ss2.push k if k
  ss = ss2
  ss.push p.name.first if p?.name?.first
  ss.push p.name.middle if p?.name?.middle
  ss.push p.name.last if p?.name?.last
  words = {}
  for s in ss
    words[s] = true
  p.words = Object.keys words
  lang = false
  for w,i in p.words
    if w.match /язык$/g
      lang = true
      p.words[i] = w.replace /язык$/g,''
  if lang
    p.words.push 'языки'
    p.words.push 'иностранный'
  awords = ""
  awords += ' '+(str ? '') for k,str of (p.location ? {})
  for el in (p.interests ? []) then for k,str of el
    awords += ' '+(str ? '') if typeof str == 'string'
  for el in (p.check_out_the_areas ? []) then for k,str of el
    awords += ' '+(str ? '') if typeof str == 'string'
  for el in (p.education ? []) then for k,str of el
    awords += ' '+(str ? '') if typeof str == 'string'
  for el in (p.work ? []) then for k,str of el
    awords += ' '+(str ? '') if typeof str == 'string'
  for k,str of p.name
    awords += ' '+(str ? '') if typeof str == 'string'
  for k,str of p.phone
    awords += ' '+(str.replace?(/\D/gmi,'').substr(-10) ? '') if typeof str == 'string'
  for k,str of p.email
    awords += ' '+(str ? '') if typeof str == 'string'
  awords += " " + (p.reason ? '') if typeof p.reason == 'string'
  awords += " " + (p.slogan ? '') if typeof p.slogan == 'string'
  awords += " " + (p.about ? '') if typeof p.about == 'string'
  awords += " " + (p.login ? '') if typeof p.login == 'string'
  awords += " " + (p.login?.replace?(/\D/gmi,'').substr(-10) ? '') if typeof p.login == 'string'
  for sname,sbj of p.subjects
    awords += ' '+sname
    for el in (sbj.course ? [])
      awords += ' '+(el ? '')
      awords += ' '+(sbj.description ? '')
      awords += ' '+tag for tag of sbj.tags
  awords = awords.replace /[^\s\w\@\-а-яА-ЯёЁ]/gim, ' '
  awords = awords.replace /\s+/gi,' '
  awords = awords.replace /^\s+/gi,''
  awords = awords.replace /\s+$/gi,''
  awords = awords.split ' '
  Awords = {}
  Awords[_diff.prepare(word)] = true for word in awords
  awords = Awords
  p.awords = awords
  _toSkip =
    _client : true
    awords : true
    words : true
  obj._client = {}
  for k,v of obj
    continue if _toSkip[k]
    obj._client[k] = v

  yield _invoke @redis,'hset','parsedTutors',id, JSON.stringify obj
  yield @jobs.signal 'reloadTutor-changed',id
