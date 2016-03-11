
@parse = (data) =>
  i = 0;
  r = {}
  r[ data[i++] ] = true while (data[i])
  data.sub_exist = r
  return data