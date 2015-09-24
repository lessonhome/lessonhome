


class @main
  constructor : ->
    Wrap @
  show : =>
    best = yield Feel.dataM.getBest 4
    for b in best
      cl = @tree.suit_tutors.class.$clone()
      dom =$('<div class="suit_tutor"></div>')
      dom.append cl.dom
      yield cl.setValue b
      @found.suit_tutors.append dom



