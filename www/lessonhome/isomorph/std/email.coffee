@prepare = (str = '') =>
#  str = _string.prepare(str)
  str.replace(/\s+/g, '')

@check = (str) =>
#  return false unless _string.check(str)
  re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  re.test @prepare(str)