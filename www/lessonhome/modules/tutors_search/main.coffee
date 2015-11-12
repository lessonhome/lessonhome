class @main
  constructor : ->
    $W @
  Dom : =>
    @rangeEl  = @found.range_ui
    slider    = document.getElementById('slider')
    priceMin  = document.getElementById('pricemin')
#    Feel.urlData.on 'change', @refilter
  show: =>
#    @tree.value.price_left
    urlPriceMin = yield Feel.urlData.get 'mainFilter','price.left'
    priceMinDefault = yield Feel.urlData.getF 'mainFilter','price.left'
    urlPriceMax = yield Feel.urlData.get 'mainFilter','price.right'

    console.log priceMinDefault

    priceMin  = document.getElementById('pricemin')
    priceMax  = document.getElementById('pricemax')
    $('.megaselect').material_select()
    ##range element init
    noUiSlider.create(slider, {
      start: [urlPriceMin, urlPriceMax],
      connect: true,
      step: 50,
      range: {
        'min': 0,
        'max': 6000
      }
    })

    $('.optgroup').on 'click', (e)=>
      thisGroup = e.currentTarget
      thisGroupNumber = $(thisGroup).attr('data-group')
      thisOpen = $(thisGroup).attr('data-open')
      console.log thisOpen
      if thisOpen == '0'
        $('li[class*="subgroup"]').slideUp(400)
        $('.optgroup').attr('data-open', 0)
        $('.subgroup_' + thisGroupNumber).slideDown(400)
        $(thisGroup).attr('data-open', 1)
      else
        $('.subgroup_' + thisGroupNumber).slideUp(400)
        $(thisGroup).attr('data-open', 0)


    ##range element min price
    slider.noUiSlider.on 'update', (values, handle)=>
      priceMin.value = values[0] + ' руб.'
      priceMax.value = values[1] + ' руб.'
    priceMin.addEventListener 'change', =>
      slider.noUiSlider.set([parseInt(priceMin.value), null])
    priceMax.addEventListener 'change', =>
      slider.noUiSlider.set([null, parseInt(priceMax.value)])

    @found.tutors_list.find('>div').remove()
#    console.log yield Feel.urlData.set 'mainFilter','price.left',500

    numTutors = 5
    tutors = yield Feel.dataM.getByFilter numTutors, (@tree.filter ? {})
    tutors ?= []
    if tutors.length < numTutors
      newt = yield Feel.dataM.getByFilter numTutors*2, ({})
      exists = {}
      for t in tutors
        exists[t.index]= true
      i = 0
      while tutors.length < numTutors
        t = newt[i++]
        break unless t?
        continue if exists[t.index]
        tutors.push t
    for tutor,i in tutors
      clone = @tree.tutor.class.$clone()
      clone.dom.css opacity:0
      @found.tutors_list.append clone.dom
      yield clone.setValue tutor
      clone.dom.show()
      clone.dom.animate (opacity:1),1400
#  refilter : =>
