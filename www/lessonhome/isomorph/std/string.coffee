

@prepare = (str = '') ->

  if str.trim?
    str = str.trim()
  else
    str = str.replace(/^\s+|\s+$/gm,'')

  return str

@check = (str) -> typeof(str) is 'string'