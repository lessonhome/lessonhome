


class @main
  constructor : ->
    Wrap @
  Dom : =>
    #link = $ '<script src="https://api-maps.yandex.ru/2.1/?load=Map&lang=ru_RU" type="text/javascript"></script>'
    #$('body').append link
    #console.log link
    #link[0].on 'load', =>
    # console.log 'load'
    ymaps.ready @test
  test : =>
    map = new ymaps.Map "map",{
      center  : [55.76,37.64]
      zoom    : 7
    }



