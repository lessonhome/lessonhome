

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @template =
      backcall : @dom.find('.container .backcall .template')

    @dom.find('.header .item').click (e)=> Q.spawn =>
      cl = ($(e.target).attr 'class').match(/\w+$/)[0]
      @dom.find('.container').attr 'class', 'container '+cl
      yield @['on'+cl]()

  onbackcall : =>
    data = yield @$send './load'
    dom  = @dom.find '.container .backcall'
    dom.empty()
    for bc in data.backcall
      @template.
      console.log bc




