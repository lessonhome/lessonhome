class @main
  constructor : ->
    $W @
  Dom : =>
    @mapContainer = @found.map_container
    ymaps.ready @initMap
  show: =>

  initMap: =>
    lessonHome_map = ymaps.Map('lessonhome_map', {
      center: [55.76, 37.64],
      zoom: 10
    })
    
