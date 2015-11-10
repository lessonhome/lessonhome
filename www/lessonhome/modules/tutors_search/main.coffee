class @main
  constructor : ->
    $W @
  Dom : =>
    @rangeEl = @found.range_ui
    slider = document.getElementById('slider')
  show: =>
    console.log $(@rangeEl)
    ##range element init
    noUiSlider.create(slider, {
      start: [500, 3500],
      connect: true,
      step: 100,
      range: {
        'min': 500,
        'max': 3500
      },
      format: wNumb({
        decimals: 0
      })
    })

    @found.tutors_list.find('>div').remove()
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