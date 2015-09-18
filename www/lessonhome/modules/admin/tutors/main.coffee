

class @main
  constructor : ->
    Wrap @
  Dom : =>
    @template =
      backcall : @dom.find('.container .content.backcall .template')
      nophoto :  @dom.find('.container .content.nophoto .template')
      time :  @dom.find('.container .content.time .template')

    @dom.find('.header .item').click (e)=> Q.spawn =>
      cl = ($(e.target).attr 'class').match(/\w+$/)[0]
      @dom.find('.container').attr 'class', 'container '+cl
      @data = yield @$send './load'
      yield @['on'+cl]()
    @data = yield @$send './load'
    yield @ontime()

  onbackcall : =>
    dom  = @dom.find '.container .content.backcall'
    dom.empty()
    for bc in @data.backcall
      row = @template.backcall.clone()
      row.find('.name').text bc.backcall.name
      row.find('.time').text new Date(bc.backcall.time).toUTCString()
      row.find('.phone').text bc.backcall.phone
      row.find('.comment').text bc.backcall.comment
      row.find('.type').text bc.backcall.type
      @relogin row,bc.account.index
      dom.append row
  ontime : =>
    dom  = @dom.find '.container .content.time'
    dom.empty()
    for p in @data.time
      row = @template.time.clone()
      bc = p.person
      row.find('.name').text [bc.last_name ? '',bc.first_name ? '',bc.middle_name ? ''].join ' '
      arr =  [(bc.email ? [])...,(bc.phone ? [])...,p.login].filter (a)-> a
      row.find('.contacts').html arr.join '<br>'
      row.find('.time').text new Date(p.accessTime).toUTCString()
      @relogin row,p.index
      dom.append row

  onnophoto : =>
    dom  = @dom.find '.container .content.nophoto'
    dom.empty()
    for bc in @data.nophotos
      row = @template.nophoto.clone()
      row.find('.name').text [bc.last_name ? '',bc.first_name ? '',bc.middle_name ? ''].join ' '
      arr =  [(bc.email ? [])...,(bc.phone ? [])...,bc.login].filter (a)-> a
      row.find('.contacts').html arr.join '<br>'
      @relogin row,bc.index
      dom.append row
  relogin : (dom,index)=> dom.dblclick => Q.spawn =>
    yield Feel.root.tree.class.$send('/relogin',index)
    yield Feel.go '/form/tutor/login',true






