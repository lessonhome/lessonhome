

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
  out = []
  _out = []
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.price_left <= mf?.price?.right
    continue unless p.price_right >= mf?.price?.left
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
    do (p)=> p.sortf = (byf)-> (p.sorts.subject*1000 ? 0)*100+(byf)
    out.push p
  nd = new Date().getTime()
  switch mf.sort
    when 'rating'
      out.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
      _out.sort (a,b)=> -(a.sortf(a.rating/5)-b.sortf(b.rating/5))
    when '-rating'
      out.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
      _out.sort (a,b)=> -(a.sortf(5/a.rating)-b.sortf(5/b.rating))
    when 'price'
      out.sort (a,b)=>-(a.sortf(5000/a.price_left)-b.sortf(5000/b.price_left))
      _out.sort (a,b)=>-(a.sortf(5000/a.price_left)-b.sortf(5000/b.price_left))
    when '-price'
      out.sort (a,b)=> -(a.sortf(a.price_left/5000)-b.sortf(b.price_left/5000))
      _out.sort (a,b)=> -(a.sortf(a.price_left/5000)-b.sortf(b.price_left/5000))
    when 'experience'
      out.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
      _out.sort (a,b)=> -(a.sortf(ex(a.experience)/10)-b.sortf(ex(b.experience)/10))
    when '-experience'
      out.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
      _out.sort (a,b)=> -(a.sortf(10/ex(a.experience))-b.sortf(10/ex(b.experience)))
    when 'register'
      out.sort (a,b)=> -(a.sortf(a.registerTime/nd)-b.sortf(b.registerTime/nd))
      _out.sort (a,b)=> -(a.sortf(a.registerTime/nd)-b.sortf(b.registerTime/nd))
    when '-register'
      out.sort (a,b)=> -(a.sortf(nd/a.registerTime)-b.sortf(nd/b.registerTime))
      _out.sort (a,b)=> -(a.sortf(nd/a.registerTime)-b.sortf(nd/b.registerTime))
    when 'access'
      out.sort (a,b)=> -(a.sortf(a.accessTime/nd)-b.sortf(b.accessTime/nd))
      _out.sort (a,b)=> -(a.sortf(a.accessTime/nd)-b.sortf(b.accessTime/nd))
    when '-access'
      out.sort (a,b)=> -(a.sortf(nd/a.accessTime)-b.sortf(nd/b.accessTime))
      _out.sort (a,b)=> -(a.sortf(nd/a.accessTime)-b.sortf(nd/b.accessTime))
  ret =  [out...]#,_out...]
  ret2 = []
  ret2.push p.index for p in ret
  return ret2




