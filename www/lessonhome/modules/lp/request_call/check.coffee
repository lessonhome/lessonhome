@getPhone = (phone) => @getText(phone).replace(/^\+7/, '8').replace(/[^\d]/g, '')
@getText = (text) => text.replace(/^\s+/g, '').replace(/\s+$/g, '')
@check = (f)=>
  phone = @getPhone(f.tel_number)
  name = @getText(f.your_name)
  errs = []
  if f.your_name.length == 0 or name.length == 0
    errs.push 'empty_name'

  if f.tel_number.length == 0 or phone.length == 0
    errs.push 'empty_phone'

  if (f.tel_number.length > 0 and phone.length == 0) or 0 < phone.length < 10
    errs.push 'wrong_phone'
  return errs
