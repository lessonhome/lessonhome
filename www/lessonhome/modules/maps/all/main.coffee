

getPoint = (str)->
  p = str.split " "
  return [+p[1],+p[0]]

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @div = @found.map
    #@go 'Ивантеевская, дом 4, 1 56'#@tree.value if @tree.value?
    #@go 'береговой проезд дом 2 строение 3'#@tree.value if @tree.value?
    #ymaps.ready =>
    #  @go 'береговой проезд 2 3'
  show : =>
    yield @init()
  init : =>
    obj = yield @resolveAddress 'Москва'
    map = new ymaps.Map @div[0],obj.bounds
    preps = yield Feel.dataM.getBest 1000000
    for p in preps
      l = p.location
      s = ""
      s += (l.city ? 'Москва')+", "
      if l.street
        s += "#{l.street ? ''}, #{l.house ? ''}, #{l.building ? ''}"
      else if l.metro
        s += "#{l.metro ? ''}"
      else if l.area
        s += "#{l.area ? ''}"
      n = (Object.keys(p.subjects ? {})?.join? ', ') ? ''
      n += "<br> #{p.name?.last ? ''} #{p.name?.first ? ''} #{p.name?.middle ? ''}<br>"
      link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index:p.index})
      n += s+'<br>'
      do (s,n,link)=> @resolveAddress(s).then (obj)=>
        return unless obj
        myPlacemark = new ymaps.Placemark(obj.pos, {
          content: n#obj?.name
          balloonContent: n+"<br>"+obj.bContent+"<br><a href='"+link+"'>"+link+"</a>"
        })
        map.geoObjects.add myPlacemark
  go : (search)=>
    d = Q.defer()
    @_go search,d
    .done()
    return d.promise
  _go : (search,d)=> ymaps.ready =>
    search = "Москва, "+search
    $.ajax
      url: "https://geocode-maps.yandex.ru/1.x/"
      data :
        geocode : search
        format : "json"
      jsonp: "callback"
      dataType : "jsonp"
      success: (res)=>
        first = res?.response?.GeoObjectCollection?.featureMember?[0]?.GeoObject

        return d.resolve false unless first?
        pos = first.Point.pos.split " "
        pos[0] *= 1
        pos[1] *= 1
        pos2 = [pos[1],pos[0]]
        console.log first,pos
        console.log ymaps
        myPlacemark = new ymaps.Placemark(pos2, {
            content: first?.name
            balloonContent: first?.metaDataProperty?.GeocoderMetaData?.text
        })
        bounds = ymaps.util.bounds.getCenterAndZoom(
          [getPoint(first.boundedBy.Envelope.lowerCorner),
          getPoint(first.boundedBy.Envelope.upperCorner)],
          #[[55.7, 37.6], [55.8, 37.7]],
          [@div.width(), @div.height()]
        )
        bounds.zoom-=2
        map = new ymaps.Map @div[0],bounds
        map.geoObjects.add myPlacemark
        d.resolve true
      error : (err)=>
        console.error err
        return d.resolve false

  resolveAddress : (search)=>
    d = Q.defer()
    ymaps.ready => $.ajax
      url: "https://geocode-maps.yandex.ru/1.x/"
      data :
        geocode : search
        format : "json"
      jsonp: "callback"
      dataType : "jsonp"
      success: (res)=>
        first = res?.response?.GeoObjectCollection?.featureMember?[0]?.GeoObject
        return d.resolve null unless first?
        pos = first.Point.pos.split " "
        pos[0] *= 1
        pos[1] *= 1
        pos2 = [pos[1],pos[0]]
        console.log first,pos
        console.log ymaps
        #myPlacemark = new ymaps.Placemark(pos2, {
        #    content: first?.name
        #    balloonContent: first?.metaDataProperty?.GeocoderMetaData?.text
        #})
        bounds = ymaps.util.bounds.getCenterAndZoom(
          [getPoint(first.boundedBy.Envelope.lowerCorner),
          getPoint(first.boundedBy.Envelope.upperCorner)],
          #[[55.7, 37.6], [55.8, 37.7]],
          [@div.width(), @div.height()]
        )
        bounds.zoom-=2
        ret = {}
        ret.bounds = bounds
        ret.first = first
        ret.pos = pos2
        ret.name = first?.name
        ret.bContent = first?.metaDataProperty?.GeocoderMetaData?.text
        #map = new ymaps.Map @div[0],bounds
        #map.geoObjects.add myPlacemark
        d.resolve ret
      error : (err)=>
        console.error err
        return d.resolve null
    return d.promise


