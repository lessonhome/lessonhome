

getPoint = (str)->
  p = str.split " "
  return [+p[1],+p[0]]

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @div = @found.map
    @go @tree.value if @tree.value?
    #ymaps.ready =>
    #  @go 'береговой проезд 2 3'

  go : (search)=>
    d = Q.defer()
    @_go search,d
    .done()
    return d.promise
  _go : (search,d)=> ymaps.ready =>
    search = "Москва, "+search
    $.ajax
      url: "http://geocode-maps.yandex.ru/1.x/"
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
        map = new ymaps.Map @div[0],bounds
        map.geoObjects.add myPlacemark
        d.resolve true
      error : (err)=>
        console.error err
        return d.resolve false



