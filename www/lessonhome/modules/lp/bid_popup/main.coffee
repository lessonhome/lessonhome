class Radio
  constructor: (jQ) ->
    @parent = jQ
    @radio = @parent.find('input[type=radio]')
  val: (val) ->
    results = null

    @radio.each ->
      if val?

        if this.value == val
          this.checked = true

      else if this.checked
        results = this.value
        return false

    return results


class @main extends EE
  contructor : ->
    $W @
    @accessory = null
  Dom : =>
    @html = $('html')
    @thisScroll = @getScrollWidth()
#    @found.m_select.material_select()

#    @found.demo_finish.on 'click', @miniBidSend
#    @found.demo_supplement.on 'click', @bidSupplementShow
    @found.req_full_send.on 'click', =>
      Q.spawn =>

        if (errs = yield @sendForm()).length == 0
          @miniBidSend()
          yield Feel.jobs.signal? "bidSuccessSend"
          @found.demo_supplement.one 'click', @bidSupplementShow
        else
          @showError errs

    yield Feel.jobs.listen 'openBidPopup',@jobOpenBidPopup

    @forms = {
      name: @found.name
      phone: @found.phone
      prices: @found.price
      subjects: @found.subjects
      metro: @found.metro
      status: @found.status
      gender: new Radio @found.sex
      comment: @found.comment
    }

#    @found.phone.mask '9 (999) 999-99-99'
    @found.subjects.material_select()
    @found.metro.material_select()
    @found.status.material_select()
    @found.price.material_select()


    @forms.name.on? 'blur', @_getListenerPupil 'name'
    @forms.phone.on? 'blur', @_getListenerPupil 'phone'
    @forms.subjects.on? 'change', @_getListener 'subjects', @forms.subjects

  _ejectUnique : (arr = []) =>
    result = []
    exist = {}
    (result.push(a); exist[a] = true) for a in arr when !exist[a]?
    return result

  _getListener : (name, el) =>
    return => Q.spawn =>
#      yield Feel.urlData.set 'tutorsFilter', {"#{name}":el?.val?()}
      yield Feel.sendActionOnce('interacting_with_form', 1000*60*10)



  _getListenerPupil : (name) =>
    return  (e) =>
      Q.spawn =>
        yield Feel.urlData.set 'pupil', {"#{name}": $(e.currentTarget).val()}
        yield Feel.sendActionOnce('interacting_with_form', 1000*60*10)
        @sendForm(true) if name is 'phone'

  show: =>
    setTimeout @metroColor, 100

  jobOpenBidPopup : (bidType, accessory)=>
    @makeBid()
    
    if (bidType == 'fullBid')
      @makeFullBid()
    else if (bidType == 'callback')
      @makeCallBack()

    @accessory = accessory if accessory?

    @found.bid_popup.openModal(
      {
        in_duration: 0,
        out_duration: 0
        ready: =>
          $("body").css("margin-right", @thisScroll + "px")
        complete: =>
          $("body").css("margin-right", "")
      }
    )
  miniBidSend: =>
    #отправка быстрой формы
    @found.req_body.fadeOut 300, =>
      @found.longer.show()
      @found.req_success.fadeIn 300

  bidSupplementShow : =>
    #функция показа подробной формы по нажатию ДОПОЛНИТЬ ЗАЯВКУ
    @found.req_success.fadeOut 300, =>
      @found.full_btn.hide()
      @found.req_body.fadeIn 300

  makeFullBid: =>
    @found.full_btn.hide()
    @found.longer.show()
    @found.req_success.hide()
    @found.req_body.show()

  makeCallBack: =>
    @found.bid_popup.addClass('callback')

  makeBid: =>
    @found.bid_popup.removeClass('callback')

  getScrollWidth : =>
    div = $('<div>').css {
      position : 'absolute'
      top: '0px'
      left: '0px'
      width: '100px'
      height: '100px'
      visibility: 'hidden'
      overflow: 'scroll'
    }
    @html.find('body:first').append div
    width = div.get(0).offsetWidth - div.get(0).clientWidth
    div.remove()
    return width

  getExist: (arr) =>
    exist = {}
    if arr instanceof Array then for l in arr then exist[l] = true
    return exist

  sendForm: (quiet = false) =>
    data = @getValue() # yield Feel.urlData.get 'pupil'
    data.linked = yield Feel.urlData.get 'mainFilter','linked'

    errs = @js.check data

    if errs.length == 0
      {status, errs, err} = yield @$send('./save', data, quiet && 'quiet')
      if status == 'success'
        Feel.sendActionOnce 'bid_popup'
        url = yield Feel.urlData.getUrl true
        url = url?.replace?(/\/?\?.*$/, '')
        url = '/' if url is ''

        switch @accessory
          when 'menu', 'empty', 'fast', 'motivation', 'add_tutors'
            name = @accessory
          else
            name = 'popup'

        Feel.sendActionOnce 'bid_action', null, {name, url}
        return []
      errs?=[]
      errs.push err if err

    Feel.sendAction 'error_on_page'
#    @showError errs
    return errs

  setValue: (v) =>
    @forms.phone.val(v.phone)
    @forms.name.val(v.name)
    @forms.subjects.val(v.subjects).trigger('update')
    @forms.metro.val(v.metro).trigger('update')

  getValue: =>
    r = {}
    for own key, el of @forms then r[key] = el.val()
    for k in ['metro', 'status']
      r[k] = @getExist r[k]
    r['subjects'] = @_ejectUnique r['subjects']
    return r

  showError: (errs)  =>
    for e in errs
      switch e
        when 'wrong_phone'
          @errInput @forms.phone, 'Введите корректный телефон'
        when 'empty_phone'
          @errInput @forms.phone, 'Введите телефон'


  metroColor :  =>
    return unless @tree.metro_lines?
    @found.metro.siblings('ul').find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_lines[name[0]]?
      elem = $('<i class="material-icons middle-icon">fiber_manual_record</i>')
      elem.css {color: @tree.metro_lines[name[0]].color}
      li.find('span').prepend(elem)

  errInput: (input, error) =>

    if error?
      input.next('label').attr 'data-error', error
      parent = input.closest('.input-field')

      if parent.length and !parent.is('.err_show')
        parent.addClass('err_show')
        bottom = parent.stop(false, true).css 'margin-bottom'
        parent.animate {marginBottom: parseInt(bottom) + 17 + 'px'}, 200
        input.one 'blur', ->
          parent
          .removeClass('err_show')
          .stop().animate {marginBottom: bottom}, 200, ->
            parent
            .css 'margin-bottom', ''

    input.addClass('invalid')
