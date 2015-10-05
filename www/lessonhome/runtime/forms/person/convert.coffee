
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
  $avatar  : (data)->
    if data.avatar? and data.avatar != []
      ava = data.avatar[data.avatar.length-1]
      if data.uploaded[ava+'high']?
        data.uploaded[ava+'high']
  $uploaded : (data) ->
    W = 738
    HMIN = 150
    HMAX = 350
    d = 5
    layers = []
    layer = undefined
    a = 0
    n = 0
    photos = []
    for p in data?.photos ? []
      photos.push data.uploaded?[p]
    photos.reverse()
    for p in photos
      continue unless p
      unless layer
        a = 0
        layer = {
          photos : []
        }
      na = a + p.width/p.height
      nn = n+1
      nh = (W-nn*2*d)/na
      if (nh>HMIN) || (nn<=1)
        layer.photos.push p
        if nh > HMAX
          nh = HMAX
        layer.height = nh
        n = nn
        a = na
      else
        layers.push layer
        a = (p.width/p.height)
        n = 1
        layer = {
          height : (W-2*d)/a
          photos : [p]
        }
        if layer.height > HMAX
          layer.height = HMAX
    layers.push layer if layer
    for layer in layers
      shift = 0
      for p,i in layer.photos
        p.left = shift + d
        shift += p.width*layer.height/p.height+d*2
    return layers
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
  $education  : (data)-> data?.education
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
    city     = location?.city
    area     = location?.area
    ret = ''
    if city?
      ret += "#{city}"
      ret += ",  #{area}" if area?
    else
      ret += "#{area}" if area?
    return ret
