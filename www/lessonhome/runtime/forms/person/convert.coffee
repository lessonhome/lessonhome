
month = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь']



class @F2V
  $birthday     : (data)-> data?.birthday?.getDate?()
  $birthmonth   : (data)-> month[data?.birthday?.getMonth?()]
  $birthyear    : (data)-> data?.birthday?.getFullYear?()
  $birthdate    : (data)->
    d = data?.birthday
    return unless d
    return "#{d?.getDate?()}.#{d?.getMonth?()+1}.#{d?.getFullYear?()}"
  $firstphone   : (data)-> data?.phone?[0]
  $phone   : (data)-> data?.phone?[0]
  $phone2  : (data)-> data?.phone?[1]
  $email   : (data)-> data?.email?[0]
  $skype   : (data)-> data?.social_networks?.skype?[0]
  $site    : (data)-> data?.site?[0]
  $avatar       : (data)-> data?.ava?[data?.ava?.length-1] if data?.ava?.length > 0
  $avatars      : (data)-> data?.ava
  $email_first  : (data)-> data?.email?[0]
  $interests0_description : (data)-> data?.interests?[0]?.description
  $interests : (data)-> data?.interests?[0]?.description
  $city       : (data)-> data?.location?.city
  $country    : (data)-> data?.location?.country
  $work       : (data)-> data?.work?[0]
  $workplace  : (data)-> data?.work?[0]?.place
  $ecity      : (data)-> data?.education?[0]?.city
  $ename      : (data)-> data?.education?[0]?.name
  $efaculty   : (data)-> data?.education?[0]?.faculty
  $echair     : (data)-> data?.education?[0]?.chair
  $equalification : (data)-> data?.education?[0]?.qualification
  $eperiod    : (data)->
    e = data?.education?[0]
    if e?.period?.start && e?.period?.end
      "#{e.period.start} - #{e.period.end} гг."
  $edu        : (data)-> data?.education?[0]
  $location   : (data)-> data?.location
