
@prepare = (phone = '')->
#  phone = _string.prepare(phone)
  phone = phone.replace /\D/g,''
  phone = phone.substr(1) if phone.length == 11 and phone.match /^[7|8]/
  return phone


@check  = (phone)->
#  return false unless _string.check str
  phone = @prepare(phone)
  return false if !phone.length or phone.length > 20
  return true
