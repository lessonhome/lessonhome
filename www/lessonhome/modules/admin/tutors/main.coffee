

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @template =
      backcall : @dom.find('.container .content.backcall .template')

    @dom.find('.header .item').click (e)=> Q.spawn =>
      cl = ($(e.target).attr 'class').match(/\w+$/)[0]
      @dom.find('.container').attr 'class', 'container '+cl
      yield @['on'+cl]()

  onbackcall : =>
    data = yield @$send './load'
    dom  = @dom.find '.container .content.backcall'
    dom.empty()
    for bc in data.backcall
      row = @template.backcall.clone()
      row.find('.name').text bc.backcall.name
      row.find('.time').text new Date(bc.backcall.time).toUTCString()
      row.find('.phone').text bc.backcall.phone
      row.find('.comment').text bc.backcall.comment
      row.find('.type').text bc.backcall.type
      dom.append row
      console.log bc
  ontime : =>




