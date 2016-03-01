

mscllspn = 'll=37.620393,55.75396&spn=0.641442,0.466439'



class YandexMap

  init : =>
    @redis = yield _Helper('redis/main').get()
    @jobs  = yield _Helper('jobs/main')
    @jobs.client 'maps',@client #TODO
    @cache = yield _invoke @redis,'hgetall','yandex_cache'
    @cache ?= {}
    @cache[key] = JSON.parse val || "{}" for key,val of @cache

    yield @jobs.listen 'yandexParsePlaces',@parsePlaces

  client : (auth,location)=>
    @parsePlaces [location]
  requestPoint : (location)=>
    hash = 'point_'+location
    return @cache[hash] if @cache[hash]?
    ret = yield _wget 'https','geocode-maps.yandex.ru',
      "/1.x/?format=json&results=1&rspn=1&geocode=#{encodeURIComponent(location)}&#{mscllspn}"
    ret = JSON.parse ret?.data || "{}"
    mdp = ret?.response?.GeoObjectCollection?.metaDataProperty
    fm  = ret?.response?.GeoObjectCollection?.featureMember
    fm0 = fm?[0] || {}
    @cache[hash] = fm0
    Q.spawn => _invoke @redis,'hset','yandex_cache',hash,JSON.stringify fm0
    return fm0
  requestKind : (geo,kind='metro',dist='0.04')=>
    point = geo?.GeoObject?.Point?.pos?.replace?(' ',',') || ""
    return {} unless point
    hash = "kind_#{kind}_#{dist}_#{point}"
    return @cache[hash] if @cache[hash]?
    ret = yield _wget 'https','geocode-maps.yandex.ru',
      "/1.x/?format=json&results=150&rspn=1&geocode=#{point}&kind=#{kind}&spn=#{dist},#{dist}"
    ret = JSON.parse ret.data || "{}"
    mdp = ret?.response?.GeoObjectCollection?.metaDataProperty
    fm  = ret?.response?.GeoObjectCollection?.featureMember
    fm ?= []
    @cache[hash] = fm
    Q.spawn => _invoke @redis,'hset','yandex_cache',hash,JSON.stringify fm
    return fm

  parsePlaces : (places=[])=>
    metro = {}
    areas = {}
    geos  = []
    qs = for place in places then @parsePlace place
    qs = yield Q.all qs
    for q in qs
      continue unless q
      if q.metro? then for m in q.metro then metro[m] = true if m
      areas[q.area] = true if q.area
      geos.push q.geo if q.geo
    metro = Object.keys(metro).sort()
    areas = Object.keys(areas).sort()
    geos.sort (a,b)-> if a.GeoObject.Point.pos < b.GeoObject.Point.pos then 1 else -1
    return {
      metro
      areas
      geos
    }

  parsePlace : (place)=>
    geo   = yield @requestPoint place
    return unless geo?.GeoObject?.boundedBy?.Envelope?.lowerCorner?
    x1 = geo.GeoObject.boundedBy.Envelope.lowerCorner.split ' '
    x2 = geo.GeoObject.boundedBy.Envelope.upperCorner.split ' '
    d = (x2[0]-x1[0])+(x2[1]-x1[1])
    return if d > 0.1
    [metro,areas] = yield Q.all [
      @requestKind geo,'metro','0.04'
      @requestKind geo,'district','0.2'
    ]
    if metro.length < 5
      metro = yield @requestKind geo,'metro','0.07'
    metro = for m in metro then m.GeoObject.name.replace 'метро ',''
    area  = areas?[0]?.GeoObject?.name || place
    metro ?= []
    return {
      geo
      area
      metro
    }

 

module.exports = YandexMap





