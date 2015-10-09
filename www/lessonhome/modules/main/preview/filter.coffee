

ex = (v)=>
  v = '' unless typeof v == 'string'
  return 1 if v?.match? '1'
  return 2 if v?.match? '3'
  return 3 if v?.match? '4'
  return 0

if window?.$Feel?.root?
  _isNode = false
else
  _isNode = true
cnum = 0
@filter = (input,mf)=> do Q.async =>
  if mf.price.right > 3000
    mf.price.right = 300000
  if mf.price.left < 600
    mf.price.left = 0
  out = []
  out2 = []
  out3 = []
  out4 = []
  _out = []
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.left_price <= mf?.price?.right
    continue unless p.right_price >= mf?.price?.left
    p.sorts = {}
    unless _isNode
      if cnum > 30
        yield Q()
        cnum = 0
    cnum++
    ss = Object.keys(p?.subjects ? {})
    ss2 = []
    for s in ss
      s = s.split /[,;\.]/
      for k in s
        k = k.replace /^\s+/,''
        k = k.replace /\s+$/,''
        ss2.push k if k
    ss = ss2
    ss.push p.name.first  if p?.name?.first
    ss.push p.name.middle if p?.name?.middle
    ss.push p.name.last   if p?.name?.last
    words = {}

    nwords = []
    awords = ""
    awords += ' '+(str ? '') for k,str of (p.location ? {})
    for el in (p.interests ? []) then for k,str of el
      awords += ' '+(str ? '') if typeof str == 'string'
    #console.log awords
    for el in (p.education ? []) then for k,str of el
      awords += ' '+(str ? '') if typeof str == 'string'
    #console.log awords
    for el in (p.work ? []) then for k,str of el
      awords += ' '+(str ? '') if typeof str == 'string'
    #console.log awords
    for k,str of p.name
      awords += ' '+(str ? '') if typeof str == 'string'
    for k,str of p.phone
      awords += ' '+(str.replace?(/\D/gmi,'').substr(-10) ? '') if typeof str == 'string'
    for k,str of p.email
      awords += ' '+(str ? '') if typeof str == 'string'
    #console.log awords
    awords += " " + (p.reason ? '') if typeof p.reason == 'string'
    #console.log awords
    awords += " " + (p.slogan ? '') if typeof p.slogan == 'string'
    #console.log awords
    awords += " " + (p.about ? '') if typeof p.about == 'string'
    awords += " " + (p.login ? '') if typeof p.login == 'string'
    awords += " " + (p.login?.replace?(/\D/gmi,'').substr(-10) ? '') if typeof p.login == 'string'
    
    #console.log awords
    for sname,sbj of p.subjects
      awords += ' '+sname
      for el in (sbj.course ? [])
        awords += ' '+(el ? '')
        awords += ' '+(sbj.description ? '')
        awords += ' '+tag for tag of sbj.tags
    #console.log awords
    #console.log "\n\n\n\n"
    awords = awords.replace /[^\s\wа-яА-ЯёЁ]/gi, ' '
    #console.log '1',awords
    awords = awords.replace /\s+/gi,' '
    #console.log '2',awords
    awords = awords.replace /^\s+/gi,''
    #console.log '3',awords
    awords = awords.replace /\s+$/gi,''
    #console.log '4',awords
    awords = awords.split ' '
    #console.log '5',awords
    Awords = {}
    Awords[_diff.prepare(word)] = true for word in awords
    awords = Awords
    p.points = 0
    p.points2 = 0
    p.pointsNeed = false
    #console.log awords
    for course in mf.course
      course = _diff.prepare(course)
      arr = course.split ' '
      #course.replace(/[^\s\w]/g,' ').replace(/\s+/g,' ').replace(/^\s+/g,'').replace(/\s+$/g,'')
      for c in arr
        continue unless c
        p.pointsNeed = true
        for word of awords
          if c == word
            p.points += 10
            continue
          if c.length < word.length
            l = c
            r = word
          else
            l = word
            r = c
          r = r.substr 0,l.length
          if (r.length > 2) && (r == l) && (Math.abs(c.length-word.length)<4)
            p.points2 += 0.1
    p.points += p.points2 unless p.points
    #console.log mf.course,p.points,awords if p.points == 13

    continue if p.pointsNeed && (p.points <= 0)
    

    #nwords = p.about.split /[\s\.;,]/ if p?.about
    #nwords.push p.location?.area ? ''
    #nwords.push p.location?.metro ? ''
    #nwords.push p.location?.street ? ''
    for w in nwords
      w = w.replace /^\s+/,''
      w = w.replace /\s+$/,''
      if w.length >= 4
        words[w] = true
    for s in ss
      words[s] = true
    ss = Object.keys(words)
    min = -1
    exists = false
    for key,subject of mf.subject
      exists = true
      found = -1
      for s in ss
        if (s.length < 10) || (subject.length < 10)
          continue if Math.abs(s.length-subject.length)>2
        dif = _diff.match subject.replace(/язык/g,''),s.replace(/язык/g,'')
        continue if (dif< 0) || (dif>0.4)
        if (found < 0) || (dif<found)
          found = dif
      continue if found < 0
      if min < 0
        min  = 0.1+found
      else
        min *= 0.1+found
    min = 0 unless exists
    continue if min<0
    #min = Math.sqrt min
    p.subject_dist = min
    p.sorts.subject = (0.5-min)/0.5

    status = false
    for key,val of mf.tutor_status
      status = true if val
    if status
      continue unless mf.tutor_status[p.status]

    place = false
    for key,val of mf.place
      place = true if val == true
    if place
      unless p.place.other
        for key,val of p.place
          if mf.place[key]
            place = false
            break
        if place
          #if Object.keys(p.place) <= 0
          #  _out.push p
          continue

    exp = false
    for key,val of mf.experience
      exp = true if val
    if exp
      exp = 0
      exp =3 if mf.experience['bigger_experience']
      exp =2 if mf.experience['big_experience']
      exp =1 if mf.experience['little_experience']
      if ex(p.experience ? "")<exp
        continue
    if mf.gender
      continue unless mf.gender==p.gender
    do (p)=> p.sortf = (byf)-> (((p.points ? 0)*100+(p.sorts.subject ? 0))*1000)*100+(byf)
    if mf.with_photo
      continue if p.nophoto
    if mf.with_verification
      continue if p.nophoto || (p.about.length < 200)
    if !p.nophoto
      if p.about.length > 50
        out.push p
      else
        out2.push p
    else
      if p.about.length > 50
        out3.push p
      else
        out4.push p

  nd = new Date().getTime()
  switch mf.sort
    when 'rating'
      out.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
      out2.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
      out3.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
      out4.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
    when '-rating'
      out.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
      out2.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
      out3.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
      out4.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
    when 'price'
      out.sort (a,b)=>-(a.sortf(5000/a.left_price)-b.sortf(5000/b.left_price))
      out2.sort (a,b)=>-(a.sortf(5000/a.left_price)-b.sortf(5000/b.left_price))
      out3.sort (a,b)=>-(a.sortf(5000/a.left_price)-b.sortf(5000/b.left_price))
      out4.sort (a,b)=>-(a.sortf(5000/a.left_price)-b.sortf(5000/b.left_price))
    when '-price'
      out.sort (a,b)=> -(a.sortf(a.left_price/5000)-b.sortf(b.left_price/5000))
      out2.sort (a,b)=> -(a.sortf(a.left_price/5000)-b.sortf(b.left_price/5000))
      out3.sort (a,b)=> -(a.sortf(a.left_price/5000)-b.sortf(b.left_price/5000))
      out4.sort (a,b)=> -(a.sortf(a.left_price/5000)-b.sortf(b.left_price/5000))
    when 'experience'
      out.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
      out2.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
      out3.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
      out4.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
    when '-experience'
      out.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
      out2.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
      out3.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
      out4.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
    when 'register'
      out = [out...,out2...,out3...,out4...]
      out2 = out3 = out4 = []
      out.sort (a,b)=> -(a.sortf(a.registerTime/nd)-b.sortf(b.registerTime/nd))
    when '-register'
      out = [out...,out2...,out3...,out4...]
      out2 = out3 = out4 = []
      out.sort (a,b)=> -(a.sortf(nd/a.registerTime)-b.sortf(nd/b.registerTime))
    when 'access'
      out = [out...,out2...,out3...,out4...]
      out2 = out3 = out4 = []
      out.sort (a,b)=> -(a.sortf(a.accessTime/nd)-b.sortf(b.accessTime/nd))
    when '-access'
      out = [out...,out2...,out3...,out4...]
      out2 = out3 = out4 = []
      out.sort (a,b)=> -(a.sortf(nd/a.accessTime)-b.sortf(nd/b.accessTime))

  ret =  [out...,out2...,out3...,out4...]
  ret2 = []
  ret2.push p.index for p in ret
  return ret2




