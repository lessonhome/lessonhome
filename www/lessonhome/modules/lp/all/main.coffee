class @main
  constructor : ->
    $W @
  Dom : =>
    @oldScroll      = $(document).scrollTop()

    @fastest = @dom.find '.fastest'
  show: =>
    @found.open_form.click => Q.spawn => Feel.jobs.solve 'openBidPopup', 'fullBid', 'fast'

    Q.spawn =>
      filter =
        mainFilter : @tree.filter
        tutorsFilter :
          subjects : @tree?.filter?.subject
      filter = yield Feel.udata.d2u filter
      @found.go_find.attr 'href','/tutors_search?'+filter
    
    @on 'change', -> Q.spawn => Feel.sendActionOnce('interacting_with_form', 1000*60*10)
    Q.spawn => Feel.jobs.onSignal? "bidSuccessSend", => @found.open_form.fadeOut 300

    ###
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
    ###


    getListener = (name, elems) =>
      return (e) =>
        el = $(e.target)
        val = el.val()
        @tree.value ?= {}
        @tree.value[name] = val
        elems.filter(':not(:focus)').val(val).focusin().focusout()
        @emit 'change'

    @found.input_phone.on 'input', getListener('phone', @found.input_phone)
    @found.input_name.on 'input', getListener('name', @found.input_name)
    @found.input_phone.on 'change', => Q.spawn => yield @sendForm(false, true)

#    @found.input_phone.on 'input',(e)=>
#      val = $(e.target).val()
#      @tree.value ?= {}
#      @tree.value.phone = val
#      @found.input_phone.filter(':not(:focus)').val val
#      @found.input_phone.removeClass 'invalid'
#      if val
#        @found.input_phone.filter(':not(:focus)').parent().find('>i,>label').addClass 'active'
#      else
#        @found.input_phone.filter(':not(:focus)').parent().find('>i,>label').removeClass 'active'
#      @emit 'change'
#    @found.input_name.on 'input',(e)=>
#      val = $(e.target).val()
#      @tree.value ?= {}
#      @tree.value.name = val
#      @found.input_name.filter(':not(:focus)').val val
#      if val
#        @found.input_name.filter(':not(:focus)').parent().find('>i,>label').addClass 'active'
#      else
#        @found.input_name.filter(':not(:focus)').parent().find('>i,>label').removeClass 'active'
#      @found.input_name.val val
#      @emit 'change'
    @found.btn_send.on 'click',(e)=> Q.spawn => yield @sendForm($(e.target).attr('footer')=='footer')

  sendForm : (footer=false, quiet = false)=>
    error = yield Feel.root.tree.class.attached.sendForm(quiet && 'quiet' || '')
    return @found.input_phone.addClass 'invalid' if error['phone']?

    unless quiet
      @fastest.find('>:not(.on_send)').remove()
      @fastest.find('.on_send').show()
      $(window).scrollTop($(document).height()) if footer

    Feel.sendGActionOnceIf 6000,'bid_quick','form_submit'
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    value = @tree.value
    @found.input_phone.val value.phone || ''
    @found.input_name.val  value.name || ''
  getValue : =>
    phone : @tree.value.phone
    name  : @tree.value.name
