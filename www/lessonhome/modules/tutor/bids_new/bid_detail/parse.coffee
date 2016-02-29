@parse = (value) =>

  value.want_price = {}
  if value.prices?.length
    value.want_price[price] = true for price in value.prices

  return value
