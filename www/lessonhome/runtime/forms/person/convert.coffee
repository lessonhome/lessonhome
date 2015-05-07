
month = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь']



class @F2V
  $birthday     : (data)-> data?.birthday?.getDate?()
  $birthmonth   : (data)-> month[data?.birthday?.getMonth?()]
  $birthyear    : (data)-> data?.birthday?.getFullYear?()
  $firstphone   : (data)-> data?.phone?[0]
  $avatar       : (data)-> data?.ava?[data?.ava?.length-1] if data?.ava?.length > 0
  $avatars      : (data)-> data?.ava
  $email_first  : (data)-> data?.email?[0]
