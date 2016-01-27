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


class @main
  contructor : ->
    $W @

  Dom : =>
    @html = $('html')
    @thisScroll = @getScrollWidth()
#    @found.m_select.material_select()

#    @found.demo_finish.on 'click', @miniBidSend
#    @found.demo_supplement.on 'click', @bidSupplementShow
#    @found.req_full_send.on 'click', @supplementBidSend

    yield Feel.jobs.listen 'openBidPopup',@jobOpenBidPopup

    @forms = {
      name: @found.name
      phone: @found.phone
      price: new $._material_select @found.price
      subjects: new $._material_select @found.subjects
      metro: new $._material_select @found.metro
      status: new $._material_select @found.status
      sex: new Radio @found.sex
      comments: @found.comments
    }

    @getValue()

  jobOpenBidPopup : (bidType)=>
    if (bidType == 'fullBid')
      @found.bid_popup.addClass 'fullBid'

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
      @found.req_success.fadeIn 300
  bidSupplementShow : =>
    #функция показа подробной формы по нажатию ДОПОЛНИТЬ ЗАЯВКУ
    @found.req_success.fadeOut 300, =>
      @found.more_body.fadeIn 300
  supplementBidSend : =>
    #отправка подробной формы
    @found.more_body.fadeOut 300, =>
      @found.req_full_success.fadeIn 300

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

  setValue: (v) => console.log v
  getValue: =>
    r = {}
    for key, el of @forms when @forms.hasOwnProperty(key) then r[key] = el.val()
    return r