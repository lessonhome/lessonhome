@parse = (data) =>
  i = 0;
  r = {}
  r[ data[i++] ] = true while (data[i])
  data.metro_exist = r
  return data