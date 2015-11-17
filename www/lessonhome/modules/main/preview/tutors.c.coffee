
_filter = require './filter'

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




class Tutors
  constructor : ->
    $W @
    @timereload = 0
    @inited = 0
  init : =>
    return _waitFor @,'inited' if @inited == 1
    return if @inited > 1
    @redis = yield Main.service('redis')
    @redis = yield @redis.get()
    @inited = 1
    @urldata = yield Main.service 'urldata'
    @dbtutor = yield @$db.get 'tutor'
    @dbpersons = yield @$db.get 'persons'
    @dbaccounts = yield @$db.get 'accounts'
    @dbuploaded = yield @$db.get 'uploaded'
    try
      @persons = JSON.parse yield _invoke @redis, 'get', 'persons'
      for key,val of (@persons ? {})
        @index?= {}
        @index[val.index] = val
      @filters = JSON.parse yield _invoke @redis, 'get', 'filters'
    catch e
      console.error e
    finally
      unless @persons? && @index? && @filters?
        @persons ?= {}
        @index   ?= {}
        @filters ?= {}
        yield @reload()
        @inited = 2
        @emit 'inited'
      else
        @inited = 2
        @emit 'inited'
        Q.spawn =>
          yield @reload()
    setInterval =>
      Q.spawn => yield @reload()
    , 15*60*1000
    setInterval =>
      Q.spawn => yield @writeFilters()
    , 60*1000
  writeFilters  : =>
    return unless @filterChange
    @filterChange = false
    yield _invoke @redis, 'set','filters',JSON.stringify @filters

  refilterRedis : =>
    time = @refilterTime = new Date().getTime()
    filters = for f,o of (@filters ? {}) then [f,(o.num ? 0)]
    filters = filters.sort (a,b)-> b[1]-a[1]
    for f,i in filters
      f = f[0]
      o = @filters[f]
      continue unless o.redis
      unless (o.num > 1) || (i<50)
        break
      unless (o.num > 2) || (i<120)
        break
      continue unless o?.data?
      yield @filter {hash:f,data:o.data}
      return if time < @refilterTime
      yield Q.delay 10
    filters = filters.slice i
    for f,i in filters
      f = f[0]
      delete @filters[f]
  handler : ($, {filter,preps,from,count,exists})->
    yield @init() unless @inited == 2
    ret = {}
    ret.preps = {}
    if preps?
      for p in preps
        ret.preps[p] = @index[p]
    if filter?
      ex = {}
      ex[k] = true for k in exists
      ret.filters = {}
      f = ret.filters[filter.hash] = {}
      unless @filters?[filter.hash]?.indexes?
        yield @filter filter,true
      else
        @filters?[filter.hash]?.num++
      f.indexes = @filters?[filter.hash]?.indexes ? []
      count ?= 10
      if from?
        inds = f?.indexes?.slice? from,from+count
        for i in inds
          ret.preps[i] = @index[i] unless ex[k]
    return ret
  filter : (filter,inc = false)=>
    f = @filters[filter.hash] ? {}
    f.data  = filter.data
    f.num   ?= 0
    f.num++ if inc
    delete f.redis

    f.indexes = yield _filter.filter @persons,filter.data
    @filters[filter.hash] = f
    @filterChange = true
    return f
    
  reload : =>
    t = new Date().getTime()
    return @persons unless (t-@timereload)>(1000*10)
    @timereload = t
    account_  =  _invoke @dbaccounts.find({}),'toArray'

    tutor  =  _invoke @dbtutor.find({}),'toArray'#,{account:1,status:1,subjects:1,reason:1,slogan:1,about:1,experience:1,extra:1,settings:1,calendar:1,check_out_the_areas:1}), 'toArray'
    person = _invoke @dbpersons.find({hidden:{$ne:true}}),'toArray'#,{account:1,ava:1,first_name:1,middle_name:1,last_name:1,sex:1,birthday:1,location:1,interests:1,work:1,education:1}),'toArray'
    [tutor,person,account_] = [(yield tutor),(yield person),(yield account_)]
    persons = {}
    for val in tutor
      continue unless val?.account
      persons[val.account] ?= {}
      persons[val.account].tutor = val
    for val in person
      continue unless val?.account
      continue unless persons[val.account]?
      persons[val.account].person = val
    for val in account_
      continue unless val?.id
      continue unless persons[val.id]?
      persons[val.id].account = val
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
    for account,o of persons
      t = o?.tutor
      p = o?.person
      obj = {}
      obj.login = o?.account?.login
      obj.index = o.account.index
      obj.registerTime = o.account.registerTime?.getTime?() ? 0
      obj.accessTime = o.account.accessTime?.getTime?() ? 0
      obj.rating = o.rating
      obj.check_out_the_areas = t?.check_out_the_areas ? []
      obj.ratio  = p.ratio ? 1.0
      obj.nophoto = o.nophoto
      obj.account = account
      obj.landing = p.landing ? false
      obj.mcomment = p.mcomment || ''
      obj.filtration = p.filtration ? false
      obj.phone = p.phone
      obj.email = p.email
      obj.name = {}
      obj.name.first = p?.first_name
      obj.slogan = t?.slogan
      obj.interests = p?.interests
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

      for ind,val of t?.subjects
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
          d = [d.left,d.right]
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
        ns.price.right = 900*3  unless ns.price.right > 0
        ns.price.left  = 600    unless ns.price.left > 0
        ns.duration.right = 180 unless ns.duration.right > 0
        ns.duration.left  = 90  unless ns.duration.left > 0
        
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
        l = ns.price.left*60/ns.duration.left
        r = ns.price.right*60/ns.duration.right
        obj.newl = l if (!obj.newl) || (obj.newl > l)
        obj.newr = r if (!obj.newr) || (obj.newr > r)
        ns.price_per_hour  = 0.5*(r+l)
        obj.price_left  = Math.round(Math.min(obj.price_left ? ns.price.left,ns.price.left)/50)*50
        obj.price_right = Math.round(Math.max(obj.price_right ? ns.price.right, ns.price.right)/50)*50
        obj.duration_left  = Math.round(Math.min(obj.duration_left ? ns.duration.left,ns.duration.left)/15)*15
        obj.duration_right = Math.round(Math.max(obj.duration_right ? ns.duration.right, ns.duration.right)/15)*15
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
      obj.photos = []
      if p.avatar
        for ava in p.avatar
          avatar = yield _invoke @dbuploaded.find({hash : {$in : [ava+'low', ava+'high']}}),'toArray'
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
      persons[account] = obj
    rmin ?= 0
    rmax ?= 1
    if rmax <= rmin
      rmax = rmin + 1
    for acc,p of persons
      p.ratingMax = rmax
      p.ratingNow = p.rating
      p.rating = (p.rating-rmin)/(rmax-rmin)
      p.rating *= 3
      p.rating += 2
      p.rmin = rmin
      p.rmax = rmax

      
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

    @persons = persons
    @index = {}
    @filters ?= {}
    for key,f of @filters
      f.redis = true
    Q.spawn => yield @refilterRedis()
    for key,val of @persons
      @index[val.index] = val
    Q.spawn =>
      yield _invoke(@redis,'set','persons',JSON.stringify(@persons))
    return @persons

tutors = new Tutors
module.exports = tutors
