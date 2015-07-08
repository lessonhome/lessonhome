

ex = (v)=>
  v = '' unless typeof v == 'string'
  return 1 if v?.match? '1'
  return 2 if v?.match? '3'
  return 3 if v?.match? '4'
  return 0

@filter = (input,mf)=>
  out = []
  _out = []
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.price_left <= mf?.price?.right
    continue unless p.price_right >= mf?.price?.left
    console.log mf
    ss = Object.keys(p?.subjects ? {})
    min = -1
    exists = false
    for key,subject of mf.subject
      exists = true
      found = -1
      for s in ss
        dif = _diff.match subject,s
        continue if dif< 0
        if (found < 0) || (dif<found)
          found = dif
      continue if found < 0
      if min < 0
        min = found*found
      else
        min += found*found
    min = 0 unless exists
    continue if min<0
    min = Math.sqrt min
    p.subject_dist = min


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
    out.push p
  switch mf.sort
    when 'rating'
      out.sort (a,b)=> (a.rating<=b.rating)
      _out.sort (a,b)=> (a.rating<=b.rating)
    when '-rating'
      out.sort (a,b)=> (a.rating>b.rating)
      _out.sort (a,b)=> (a.rating>b.rating)
    when 'price'
      out.sort (a,b)=> (a.price_left>=b.price_left)
      _out.sort (a,b)=> (a.price_left>=b.price_left)
    when '-price'
      out.sort (a,b)=> (a.price_right<b.price_right)
      _out.sort (a,b)=> (a.price_right<b.price_right)
    when 'experience'
      out.sort (a,b)=> (ex(a.experience)<=ex(b.experience))
      _out.sort (a,b)=> (ex(a.experience)<=ex(b.experience))
    when '-experience'
      out.sort (a,b)=> (ex(a.experience)>ex(b.experience))
      _out.sort (a,b)=> (ex(a.experience)>ex(b.experience))
  return [out...,_out...]




