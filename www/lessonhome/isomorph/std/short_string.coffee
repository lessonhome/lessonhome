

@prepare = (str = '') =>
#  str = string.prepare(str)
  str.replace(/\s+/g, ' ')

@check = (str) => return string.check()
