

ex = (v)=>
  v = '' unless typeof v == 'string'
  return 1 if v?.match? '1'
  return 2 if v?.match? '3'
  return 3 if v?.match? '4'
  return 0

@filter = (input,mf)=>
  out = []
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.price_left <= mf?.price?.right
    continue unless p.price_right >= mf?.price?.left
    out.push p
  switch mf.sort
    when 'rating'
      out.sort (a,b)=> (a.rating<=b.rating)
    when '-rating'
      out.sort (a,b)=> (a.rating>b.rating)
    when 'price'
      out.sort (a,b)=> (a.price_per_hour>=b.price_per_hour)
    when '-price'
      out.sort (a,b)=> (a.price_per_hour<b.price_per_hour)
    when 'experience'
      out.sort (a,b)=> (ex(a.experience)<=ex(b.experience))
    when '-experience'
      out.sort (a,b)=> (ex(a.experience)>ex(b.experience))
  return out




