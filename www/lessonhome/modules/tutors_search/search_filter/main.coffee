class @main
  constructor : ->
    $W @
  Dom : =>
    @rangeEl  = @found.range_ui
    @filterSelectors = @found.megaselect
    slider    = document.getElementById('slider')
  show: =>
    $(@filterSelectors).material_select()

    #    @tree.value.price_left
    urlPriceMin = yield Feel.urlData.get 'mainFilter','price.left'
    urlPriceMax = yield Feel.urlData.get 'mainFilter','price.right'

    priceMin  = document.getElementById('pricemin')
    priceMax  = document.getElementById('pricemax')
    priceMinDefault = @tree.price_base.min
    priceMaxDefault = @tree.price_base.max

    ##range element init
    noUiSlider.create(slider, {
      start: [urlPriceMin, urlPriceMax],
      connect: true,
      step: 50,
      range: {
        'min': priceMinDefault,
        'max': priceMaxDefault
      }
    })

    ##range element min price
    slider.noUiSlider.on 'update', (values, handle)=>
      priceMin.value = ( values[0] * 1 ).toFixed()
      priceMax.value = ( values[1] * 1 ).toFixed()

    priceMin.addEventListener 'change', =>
      slider.noUiSlider.set([parseInt(priceMin.value), null])
    priceMax.addEventListener 'change', =>
      slider.noUiSlider.set([null, parseInt(priceMax.value)])

    $('.optgroup').on 'click', (e)=>
      thisGroup = e.currentTarget
      thisGroupNumber = $(thisGroup).attr('data-group')
      thisOpen = $(thisGroup).attr('data-open')
      if thisOpen == '0'
        $('li[class*="subgroup"]').slideUp(400)
        $('.optgroup').attr('data-open', 0)
        $('.subgroup_' + thisGroupNumber).slideDown(400)
        $(thisGroup).attr('data-open', 1)
      else
        $('.subgroup_' + thisGroupNumber).slideUp(400)
        $(thisGroup).attr('data-open', 0)
