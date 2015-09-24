


class @main
  constructor : ->
    Wrap @
  show : =>
    best = yield Feel.dataM.getBest 4
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



