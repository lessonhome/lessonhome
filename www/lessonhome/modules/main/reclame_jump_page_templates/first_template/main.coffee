


class @main
  constructor : ->
    $W @
  init : =>
    Feel.sendActionOnce 'target_page'
  show : =>
    console.log @tree.filter
    do => Q.spawn =>
      @found.link.attr 'href','/second_step?'+yield Feel.udata.d2u('mainFilter',@tree.filter)
    best = yield Feel.dataM.getByFilter 4, (@tree.filter ? {})
    
    for b,i in best
      cl = @tree.suit_tutors.class.$clone()
      dom =$('<div class="suit_tutor"></div>')
      if (i%2) == 0
        dom.addClass 'second_card'
      else
        dom.addClass 'first_card'
      dom.append cl.dom
      yield cl.setValue b
      @found.suit_tutors.append dom



