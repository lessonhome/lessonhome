class @main
  constructor: ->
    $W @
  Dom : =>
    @slickBlock = @found.slick_block

    if @tree.not_page_refresh
      @prepareLink()

    @slickBlock.slick({
      dots: false,
      infinite: true,
      slidesToShow: 4,
      slidesToScroll: 4,
      responsive: [
        {
          breakpoint: 1000,
          settings: {
            infinite: true,
            slidesToShow: 2,
            slidesToScroll: 2
          }
        },
        {
          breakpoint: 480,
          settings: {
            infinite: true,
            slidesToShow: 1,
            slidesToScroll: 1
          }
        }
      ]
    })
 
  prepareLink : ()=>
    @dom.find('a').off('click').on 'click', (e)->
      link = $(this)
      index = link.attr('data-i')
      e.preventDefault()
      if index?
        Feel.main.showTutor index, link.attr 'href'
      return false
