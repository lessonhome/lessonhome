class @main
  constructor : ->
    $W @
  Dom : =>
    @showFilter   = @found.show_filter
    @filterBlock  = @found.filter_block
    @listTutors   = @found.list_tutors
    @filterStatus = 0
  show: =>
    @found.tutors_list.find('>div').remove()

    @showFilter.on 'click', (e)=>
      thisShowButton = e.currentTarget
      if(@filterStatus == 0)
        $(thisShowButton).html('Подобрать репетиторов (1233)')
        $(@filterBlock).slideDown('fast')
        $(@listTutors).slideUp('fast')
        @filterStatus = 1
      else
        $(thisShowButton).html('Подобрать по параметрам')
        $(@filterBlock).slideUp('fast')
        $(@listTutors).slideDown('fast')
        @filterStatus = 0


    numTutors = 5
    tutors = yield Feel.dataM.getByFilter numTutors, ({subject:['Русский язык']})
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
