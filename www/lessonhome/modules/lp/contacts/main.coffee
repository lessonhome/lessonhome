class @main
  constructor : ->
    $W @
  Dom : =>
    @mapContainer = @found.map_container
    @lessonHomeCoordinates = [55.757648, 37.507358]
    @iconSrc = @found.map_img.attr 'src'
    ymaps.ready @initMap
  show: =>

  initMap: =>
    @map = new ymaps.Map(@found.map_container[0], {
      center: [55.742, 37.62211],
      zoom: 10,
      controls: []
    })
    
    @lessonHome = new ymaps.Placemark(
      @lessonHomeCoordinates,
      {
        hintContent: 'LessonHome',
        balloonContent: '
        <div class="ballon-title">LessonHome</div>
        <div class="ballon-text">Сервис по подбору репетиторов</div>
        <div class="ballon-contacts"><i class="m_icon icon_phone prefix"></i><span>+7 (495) 369-04-25</span></div>
        <div class="ballon-contacts"><i class="m_icon icon_email prefix"></i><span>support@lesshome.ru</span></div>
        '
      },
      {
        iconLayout: 'default#image'
        iconImageHref: @iconSrc
        iconImageSize: [28, 40]
      }
    )

    @map.geoObjects.add @lessonHome
