@parse = (value) =>
  if !value.subjects? and value.subject then value.subjects = [value.subject]
  return value
