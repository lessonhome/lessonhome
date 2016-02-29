

ex = (v)=>
  v = '' unless typeof v == 'string'
  return 1 if v?.match? '1'
  return 2 if v?.match? '3'
  return 3 if v?.match? '4'
  return 0

@filter = (input,mf)=> do Q.async =>
  if mf.price?.right > 3000
    mf.price?.right = 300000
  if mf.price?.left < 600
    mf.price?.left = 0
  out = []
  out2 = []
  out3 = []
  out4 = []
  _out = []
  coursearr = []
  for course in mf.course
    course = _diff.prepare(course)
    course2 = _diff.prepare(course.replace(/[^\w\@\-а-яА-ЯёЁ]/gmi,''))
    arr = course.split ' '
    coursearr = [coursearr...,arr...,course2,course2.substr(1),course2.substr(0,course2?.length-2)]
  arr = {}
  coursearr ?= []
  for c in coursearr
    continue unless c
    arr[c] = true
  coursearr = Object.keys arr
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.left_price <= mf?.price?.right
    continue unless p.right_price >= mf?.price?.left
    switch mf.page
      when 'filter'
        continue if p.nophoto
        continue if p.filtration
        continue unless p.checked
      when 'landing'
        continue if p.nophoto
        continue if p.landing
        continue if p.filtration
        continue unless p.checked
    p.points = 0
    p.points2 = 0
    p.pointsNeed = false
    for c in coursearr
      continue unless c
      p.pointsNeed = true
      for word of p.awords
        if c == word
          p.points += 10
          continue
        if c?.length < word?.length
          l = c
          r = word
        else
          l = word
          r = c
        r = r.substr 0,l?.length
        if (r?.length > 2) && (r == l) && (Math.abs(c?.length-word?.length)<4)
          p.points2 += 0.1
    p.points += p.points2 unless p.points

    continue if p.pointsNeed && (p.points <= 0)
    
    min = -1
    exists = false
    for key,subject of mf.subject
      exists = true
      found = -1
      p.words ?= []
      for s in p.words
        nw1 = subject.replace(/язык$/g,'')
        nw2 = s.replace(/язык$/g,'')
        if (nw1?.length < 10) || (nw2?.length < 10)
          continue if Math.abs(nw2?.length-nw1?.length)>2
        dif = _diff.match nw1,nw2
        continue if (dif< 0) || (dif>0.1)
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
      continue if p.nophoto || (p.about?.length < 200)
    if !p.nophoto
      if p.about?.length > 50
        out.push p
      else
        out2.push p
    else
      if p.about?.length > 50
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

