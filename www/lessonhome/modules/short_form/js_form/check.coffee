@takeData = (data = {}) =>
  name : data.name
  phone : data.phone

@check  = (data) =>
  errs = []
#  data = @takeData(data)

  if data.phone?.length
    errs.push 'wrong_phone' unless 7 <= data.phone.replace(/\D/g, '').length <= 13
  else
    errs.push 'empty_phone'

  return errs





