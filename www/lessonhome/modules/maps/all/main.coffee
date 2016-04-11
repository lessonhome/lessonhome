

getPoint = (str)->
  p = str.split " "
  return [+p[1],+p[0]]

class @main
  constructor : ->
    $W @
  Dom : =>
    @div = @found.map
  show : =>
    @geocode = $.localStorage.get('geocode') ? {}
    @nresolve   = 0
    @nresolved  = 0
    @ntutors    = 0
    @npoints    = 0
    yield @init()
  init : =>
    obj = yield @resolveAddress 'Москва'
    map = new ymaps.Map @div[0],obj.bounds
    myClusterer = new ymaps.Clusterer()
    preps = yield Feel.dataM.getBest 1000000
    for p in preps
      l = p.location
      s = ""
      s += (l.city ? 'Москва')+", "
      address = {}
      if l.street
        q = s+"#{l.street ? ''}, #{l.house ? ''}, #{l.building ? ''}"
        q = q.replace /^\s+/gmi,''
        q = q.replace /\s+$/gmi,''
        address[q] = true if q
      if l.metro
        q = l.metro.split /[\,\;\.]/
        for qq in q
          qq = qq.replace /^\s+/,''
          qq = qq.replace /\s+$/,''
          address[qq] = true if qq
      if l.area
        q =s+ "#{l.area ? ''}"
        q = q.replace /^\s+/gmi,''
        q = q.replace /\s+$/gmi,''
        address[q] = true if q
      if p.check_out_the_areas
        for a in (p.check_out_the_areas ? [])
          q = a.split /[\,\;\.]/
          for qq in q
            qq = qq.replace /^\s+/,''
            qq = qq.replace /\s+$/,''
            address[qq] = true if qq
      address = Object.keys(address)
      n = (Object.keys(p.subjects ? {})?.join? ', ') ? ''
      n += "<br> #{p.name?.last ? ''} #{p.name?.first ? ''} #{p.name?.middle ? ''}<br>"
      if p.photos?.length
        url = p.photos[p.photos.length-1].lurl
        n += "<img src='"+url+"' /><br>"
      link = '/tutor?'+yield Feel.udata.d2u('tutorProfile',{index:p.index})
      n += s+'<br>'
      n += "<a href='"+link+"'>"+link+"</a><br>"
      n += p.phone.join('<br>')+'<br>'
      n += p.email.join('<br>')+'<br>'
      @ntutors++
      for s in address then do (s,n,link,p)=> @resolveAddress(s).then (obj)=>
        return unless obj
        @npoints++
        myPlacemark = new ymaps.GeoObject({
          geometry : {
            type : "Point"
            coordinates : obj.pos
          },
          properties:{
            iconContent: (Object.keys(p.subjects ? {})?.join? ', ') ? ''
            #hintContent: (Object.keys(p.subjects ? {})?.join? ', ') ? ''
            balloonContent: n+"<br>"+obj.bContent
          }
        },{
          preset: 'islands#blueStretchyIcon'
        })
        map.geoObjects.add myPlacemark
        console.log @ntutors,@npoints,@nresolve,@nresolved
        #myClusterer.add myPlacemark
    map.geoObjects.add myClusterer
  go : (search)=>
    d = Q.defer()
    yield @_go search,d
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
    hash = CryptoJS.SHA1(escape(search)).toString().substr(0,10)
    ls = @geocode[hash]
    d = Q.defer()
    if ls then ymaps.ready => d.resolve ls
    else ymaps.ready => $.ajax
      url: "https://geocode-maps.yandex.ru/1.x/"
      data :
        geocode : search
        format : "json"
      jsonp: "callback"
      dataType : "jsonp"
      success: (res)=>
        @nresolved++
        first = res?.response?.GeoObjectCollection?.featureMember?[0]?.GeoObject
        return d.resolve null unless first?
        pos = first.Point.pos.split " "
        pos[0] *= 1
        pos[1] *= 1
        pos2 = [pos[1],pos[0]]
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
        @geocodeSet hash,ret
        d.resolve ret
      error : (err)=>
        console.error err
        return d.resolve null
    @nresolve++
    return d.promise
  geocodeSet : (hash,val)=>
    @geocode[hash]=val
    @writeGeocode()
  writeGeocode : (t=(new Date().getTime()))=>
    l = @lw || 0
    return if l > t
    if (t-l)<1000
      return setTimeout (=> @writeGeocode(t)),(1000-(t-l))
    @lw = new Date().getTime()
    console.log 'writeGeocode'
    $.localStorage.set('geocode',@geocode)
