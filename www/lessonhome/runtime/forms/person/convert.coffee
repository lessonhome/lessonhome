
month = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь']


comma = (str,next)->
  str = "" unless typeof str == 'string'
  str = str.replace /\s+$/,''
  str += "," if str && (!str.match(/\,$/))
  str += ' '
  str += next if next && (typeof next == 'string')
  return str

class @F2V
  $birthday     : (data)-> data?.birthday?.getDate?()
  $birthmonth   : (data)-> month[data?.birthday?.getMonth?()]
  $birthyear    : (data)-> data?.birthday?.getFullYear?()
  $birthdate    : (data)->
    d = data?.birthday
    return unless d
    return "#{d?.getDate?()}.#{d?.getMonth?()+1}.#{d?.getFullYear?()}"
  $firstphone   : (data)-> data?.phone?[0]
  $phone   : (data)->
    phone = data?.phone?[0]
    if !phone && data?.login?
      unless data.login?.match?(/\@/)
        phone = data.login.replace(/[^\d]]/g,"")
        if phone.length == 7
          phone = '495'+phone
    return phone

  $phone2  : (data)-> data?.phone?[1]
  $email   : (data)->
    email = data?.email?[0]
    if !email && data?.login?.match /\@/
      email = data.login
    return email
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
  $dativeName : (data)->
    name = _nameLib.get((data?.last_name ? ''),(data?.first_name ? ''),(data?.middle_name ? ''))
    return {
      first : name.firstName('dative')
      middle: name.middleName('dative')
      last  : name.lastName('dative')
    }
  $edu        : (data)-> data?.education?[0]
  $address    : (data)->
    location = data?.location
    country  = location?.country
    city     = location?.city
    street   = location?.street
    house    = location?.house
    building = location?.building
    address = ''
    address = comma(address,country)
    address = comma(address,city)
    address = comma(address,street)
    address = comma(address,house)
    address = comma(address,building)
    ###
    if street?
      if house?
        address += "#{house} "
        if building?
          address += "#{building} "
    ###
    return address
  $addressNeed : (data)->
    return "" unless data?.location?.street
    location = data?.location
    street   = location?.street
    house    = location?.house
    building = location?.building
    address = ''
    address = comma(address,street)
    address = comma(address,house)
    address = comma(address,building)
    return address
  $addressPost : (data)-> do Q.async =>
    an = yield @$addressNeed data
    return "редактировать" if an
    return "Укажите подробный адрес"

  $area     : (data)->
    location = data?.location
    console.log location
    city     = location?.city
    area     = location?.area
    ret = ''
    if city?
      ret += "#{city}"
      ret += ",  #{area}" if area?
    else
      ret += "#{area}" if area?
    return ret
