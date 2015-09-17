

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @dom.find('.header .item').click (e)=> Q.spawn =>
      cl = ($(e.target).attr 'class').match(/\w+$/)[0]
      @dom.find('.container').attr 'class', 'container '+cl
      yield @['on'+cl]()

  onbackcall : =>
    data = yield @$send './load'
    for bc in data.backcall




