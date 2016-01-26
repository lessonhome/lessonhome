class @main
  contructor : ->
    $W @

  Dom : =>
    @html = $('html')
    @thisScroll = @getScrollWidth()
    @found.m_select.material_select()

    @found.demo_finish.on 'click', @miniBidSend
    @found.demo_supplement.on 'click', @bidSupplementShow
    @found.req_full_send.on 'click', @supplementBidSend

    yield Feel.jobs.listen 'openBidPopup',@jobOpenBidPopup
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
