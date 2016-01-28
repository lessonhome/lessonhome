class Radio
  constructor: (jQ) ->
    @parent = jQ
    @radio = @parent.find('input[type=radio]')
  val: (val) ->
    results = null

    @radio.each ->
      if val?

        if this.value == val
          this.cheched = true

      else if this.checked
        results = this.value
        return false

    return results


class @main extends EE
  contructor : ->
    $W @

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
      prices: new $._material_select @found.price
      subjects: new $._material_select @found.subjects
      metro: new $._material_select @found.metro
      status: new $._material_select @found.status
      gender: new Radio @found.sex
      comment: @found.comment
    }

    @metroColor @forms.metro


    getListener = (name, el) ->
      return  (e) ->
        o = {}
        o[name] = el.val()
        Feel.urlData.set 'pupil', o

    for k in ['name', 'subjects']
      @forms[k].on? 'change', getListener k, @forms[k]

    l_phone = getListener 'phone', @forms['phone']
    @forms['phone'].on? 'change', =>
      l_phone()
      Q.spawn => @sendForm(true)

  show: =>

    @dom.find('.slide_collapse').on 'click' ,'.optgroup', (e)=>
      thisGroup = $(e.currentTarget)
      slider = thisGroup.closest('ul')
      thisGroupNumber = thisGroup.attr('data-group')
      thisOpen = thisGroup.attr('data-open')
      if thisOpen == '0'
        slider.find('li[class*="subgroup"]').slideUp(400)
        slider.find('.optgroup').attr('data-open', 0)
        slider.find('.subgroup_' + thisGroupNumber).slideDown(400)
        thisGroup.attr('data-open', 1)
      else
        slider.find('.subgroup_' + thisGroupNumber).slideUp(400)
        thisGroup.attr('data-open', 0)

  jobOpenBidPopup : (bidType)=>
    if (bidType == 'fullBid')
      @makeFullBid()

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
    data = @getValue()
    data.linked = yield Feel.urlData.get 'mainFilter','linked'

    errs = @js.check data

    if errs.length == 0
      {status, errs, err} = yield @$send('./save', data, quiet && 'quiet')
      if status == 'success'
        Feel.sendActionOnce 'bid_popup'
        return []
      errs?=[]
      errs.push err if err

    Feel.sendAction 'error_on_page'
#    @showError errs
    return errs

  setValue: (v) =>
    @forms.phone.val(v.phone).focusin().focusout()
    @forms.name.val(v.name).focusin().focusout()
    @forms.subjects.val v.subjects

  getValue: =>
    r = {}
    for key, el of @forms when @forms.hasOwnProperty(key) then r[key] = el.val()
    for k in ['metro', 'status']
      r[k] = @getExist r[k]
    return r

  showError: (errs)  =>
    for e in errs
      switch e
        when 'wrong_phone'
          @errInput @forms.phone, 'Введите корректный телефон'
        when 'empty_phone'
          @errInput @forms.phone, 'Введите телефон'


  metroColor : (_material_select) =>
    return unless @tree.metro_lines?
    _material_select.ul.find('li.optgroup').each (i, e) =>
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