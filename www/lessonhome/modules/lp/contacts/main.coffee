class @main
  constructor : ->
    $W @
  Dom : =>
    @mapContainer = @found.map_container
    ymaps.ready @initMap
  show: =>

  initMap: =>
    @map = new ymaps.Map(@found.map_container[0], {
      center: [55.76, 37.64],
      zoom: 10
    })
    
