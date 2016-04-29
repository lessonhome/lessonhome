
Date.prototype.addHours = (h)->
  this.setTime(this.getTime() + (h*60*60*1000))
  return this


class @main
  constructor : ->
    $W @
  Dom : =>
    @template =
      bids : @dom.find('.container .content.bids .template')
      backcall : @dom.find('.container .content.backcall .template')
      nophoto :  @dom.find('.container .content.nophoto .template')
      time :  @dom.find('.container .content.time .template')
      byreg :  @dom.find('.container .content.byreg .template')
      nosubject :  @dom.find('.container .content.nosubject .template')

    @dom.find('.header .item').click (e)=> Q.spawn =>
      cl = ($(e.target).attr 'class').match(/\w+$/)[0]
      @dom.find('.container').attr 'class', 'container '+cl
      yield @['on'+cl]()
      #@data = yield @$send './load'
      #yield @['on'+cl]()
    @data = yield @$send './load',{fast:true}
    yield @['on'+key]() for key of @template
    @data = yield @$send './load'
    yield @['on'+key]() for key of @template

  onbids : =>
    dom  = @dom.find '.container .content.bids'
    console.log @data
    dom.empty()
    for bc in @data.bids
      row = @template.bids.clone()
      if bc.id
        row.find('.title').text 'Сообщение'
      else
        row.find('.title').text 'Заявка'
      row.find('.name').html "#{bc.name}<br>#{bc.subject}"
      row.find('.time').html "#{new Date(bc.time).addHours(3).toUTCString()}<br>\##{bc.account.substr(-5)}"
      row.find('.phone').html "#{bc.phone || ""};<br>#{bc.email || ''}"
      row.find('.comment').text bc.comments
      lk = []
      lk.push bc.id if bc.id
      lk = [lk...,(Object.keys(bc.linked ? {}) ? [])...] if Object.keys(bc?.linked ? {})?.length
      for l,i in lk
        lk[i] = "<a target='_blank' href='https://lessonhome.ru/profile?x=#{l}'>\##{l}</a>"
      row.find('.linked').html lk.join '; '
      dom.append row
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
  onbyreg : =>
    dom  = @dom.find '.container .content.byreg'
    dom.empty()
    for p in @data.byreg
      row = @template.byreg.clone()
      bc = p.person
      row.find('.name').text [bc.last_name ? '',bc.first_name ? '',bc.middle_name ? ''].join ' '
      arr =  [(bc.email ? [])...,(bc.phone ? [])...,p.login].filter (a)-> a
      row.find('.contacts').html arr.join '<br>'
      row.find('.time').text new Date(p.registerTime).toUTCString()
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
  onnosubject : =>
    dom  = @dom.find '.container .content.nosubject'
    dom.empty()
    console.log @data.nosubject
    for id,bc of @data.nosubject
      row = @template.nosubject.clone()
      row.find('.name').text [bc.last_name ? '',bc.first_name ? '',bc.middle_name ? ''].join ' '
      arr =  [(bc.email ? [])...,(bc.phone ? [])...,bc.login].filter (a)-> a
      row.find('.contacts').html arr.join '<br>'
      @relogin row,bc.index
      dom.append row
  relogin : (dom,index)=> dom.dblclick => Q.spawn =>
    return unless index
    yield Feel.root.tree.class.$send('/relogin',index)
    yield Feel.go '/form/tutor/login',true






