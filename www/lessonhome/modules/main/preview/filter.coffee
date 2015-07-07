


@filter = (input,mf)=>
  out = []
  for acc,p of input
    continue unless p?.name?.first
    continue unless p.price_left <= mf?.price?.right
    continue unless p.price_right >= mf?.price?.left
    out.push p
  return out




